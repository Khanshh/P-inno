"""
API Routes for Fertility Simulation Models.

Endpoints:
    POST /simulation/hunault          – Chạy mô phỏng Hunault (thụ thai tự nhiên)
    GET  /simulation/hunault/info     – Thông tin về Hunault Model
    GET  /simulation/models           – Danh sách tất cả mô hình
"""

import json
import os
from datetime import datetime
import uuid
from fastapi import APIRouter, HTTPException

from app.schemas.simulation import (
    HunaultRequest,
    HunaultResponse,
    HunaultModelInfoResponse,
    SimulationModelListResponse,
    UnifiedSimulationRequest,
)
from ai.features.fertility_simulation.hunault_model import (
    predict as hunault_predict,
    HunaultInput,
    SpermInput,
    LifestyleFactors,
    SmokingStatus,
    AlcoholConsumption,
    ExerciseFrequency,
    StressLevel,
    MEDICAL_DISCLAIMER,
)
from ai.features.fertility_simulation.adapter import map_profile_to_hunault

router = APIRouter()


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DB Utils cho Simulations
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

_simulations_path = os.path.join(os.getcwd(), "data", "simulations.json")

def load_simulations():
    try:
        if os.path.exists(_simulations_path):
            with open(_simulations_path, "r", encoding="utf-8") as f:
                return json.load(f)
    except Exception as e:
        print(f"Error loading simulations: {e}")
    return []

def save_simulations(sim_list):
    try:
        with open(_simulations_path, "w", encoding="utf-8") as f:
            json.dump(sim_list, f, indent=4, ensure_ascii=False)
    except Exception as e:
        print(f"Error saving simulations: {e}")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Endpoints
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@router.get("/simulation/history")
async def get_simulation_history(user_id: str):
    """Lấy lịch sử mô phỏng của người dùng"""
    sim_list = load_simulations()
    user_sims = [s for s in sim_list if s.get("user_id") == user_id]
    
    # Sort by date descending
    user_sims.sort(key=lambda x: x.get("created_at", ""), reverse=True)
    return {"history": user_sims}


@router.post(
    "/simulation/unified",
    summary="Chạy mô phỏng hợp nhất (Dùng Hồ sơ 33 câu hỏi)",
    description=(
        "Chuyển đổi dữ liệu từ 33 câu hỏi khảo sát sang các thông số "
        "mô hình tương ứng (Hunault hoặc SART)."
    ),
)
async def run_unified_simulation(request: UnifiedSimulationRequest):
    """
    Chạy mô phỏng dựa trên model_id và hồ sơ 33 câu hỏi.
    """
    from ai.features.fertility_simulation.adapter import (
        interpret_symptoms_with_ai, 
        map_profile_to_sart,
        generate_final_report_ai
    )
    
    # Common: Define standard diagnosis for Hunault using rule-based initially
    # (Hunault doesn't strictly need diagnosis but report looks better with it)
    ai_diagnosis = await interpret_symptoms_with_ai(request.profile)
    
    if request.model_id == "hunault":
        domain_input = map_profile_to_hunault(request.profile)
        result = hunault_predict(domain_input)
        
        # Supercharge result interpretation with AI
        ai_report = await generate_final_report_ai("Hunault (Tự nhiên)", result.probability_percent, request.profile, ai_diagnosis)
        result.interpretation = ai_report
        
        hunault_resp = HunaultResponse(
            probability_percent=result.probability_percent,
            risk_level=result.risk_level.value,
            interpretation=result.interpretation,
            recommendations=result.recommendations,
            factors_summary=result.factors_summary,
            motility_used=result.motility_used,
            motility_source=result.motility_source,
            disclaimer=result.disclaimer,
        )
        
        # Save to DB
        if request.user_id:
            sim_list = load_simulations()
            sim_list.append({
                "id": str(uuid.uuid4()),
                "user_id": request.user_id,
                "model_id": request.model_id,
                "probability_percent": hunault_resp.probability_percent,
                "risk_level": hunault_resp.risk_level,
                "created_at": datetime.now().isoformat(),
                "result": hunault_resp.model_dump()
            })
            save_simulations(sim_list)
            
        return hunault_resp
        
    elif request.model_id == "sart_ivf":
        # 1. Map to SART predictor format
        sart_input = map_profile_to_sart(request.profile, ai_diagnosis)
        
        # 2. Calculate real SART IVF prob instead of mocking
        from ai.features.fertility_simulation.sart_ivf_model import predict_ivf_success
        prob = predict_ivf_success(sart_input)
        
        # 3. Supercharge with AI Report
        ai_report = await generate_final_report_ai("SART (IVF)", prob, request.profile, ai_diagnosis)
        
        res = {
            "probability_percent": prob,
            "risk_level": "moderate",
            "interpretation": ai_report,
            "recommendations": ["Nên tư vấn bác sĩ chuyên khoa IVF", "Khám sàng lọc vòi trứng"],
            "factors_summary": {
                "age": {"value": sart_input["female_age"], "impact": "neutral"},
                "bmi": {"value": round(sart_input["bmi"], 1), "impact": "neutral"},
                "diagnosis": {"value": ai_diagnosis, "label": "Nhóm bệnh lý (AI xác định)"}
            },
            "disclaimer": MEDICAL_DISCLAIMER
        }

        if request.user_id:
            sim_list = load_simulations()
            sim_list.append({
                "id": str(uuid.uuid4()),
                "user_id": request.user_id,
                "model_id": request.model_id,
                "probability_percent": prob,
                "risk_level": "moderate",
                "created_at": datetime.now().isoformat(),
                "result": res
            })
            save_simulations(sim_list)

        return res
    else:
        raise HTTPException(status_code=400, detail="Model ID không hợp lệ.")


@router.post(
    "/simulation/hunault",
    response_model=HunaultResponse,
    summary="Dự đoán khả năng thụ thai tự nhiên (Hunault Model)",
    description=(
        "Sử dụng mô hình Hunault (2004) để ước tính xác suất thụ thai tự nhiên "
        "trong 12 tháng tới.\n\n"
        "**Lưu ý về tinh dịch đồ:**\n"
        "- Nếu bạn đã có kết quả xét nghiệm: đặt `has_test_result = true` "
        "và cung cấp `motile_sperm_percent`.\n"
        "- Nếu chưa xét nghiệm: đặt `has_test_result = false` và cung cấp "
        "`lifestyle` (tuổi nam, hút thuốc, rượu bia, BMI, tập thể dục, stress). "
        "Hệ thống sẽ ước tính dựa trên lối sống."
    ),
)
async def run_hunault_simulation(request: HunaultRequest) -> HunaultResponse:
    """
    Chạy mô phỏng Hunault Model.

    Trả về xác suất thụ thai tự nhiên cùng với:
    - Giải thích chi tiết bằng tiếng Việt
    - Khuyến nghị cá nhân hóa
    - Tóm tắt các yếu tố ảnh hưởng
    """
    try:
        # Helper to convert local schema to domain input
        # Note: We reuse original logic here for backward compatibility
        from app.api.v1.routes_simulation import _to_domain_input
        domain_input = _to_domain_input(request)
        result = hunault_predict(domain_input)

        return HunaultResponse(
            probability_percent=result.probability_percent,
            risk_level=result.risk_level.value,
            interpretation=result.interpretation,
            recommendations=result.recommendations,
            factors_summary=result.factors_summary,
            motility_used=result.motility_used,
            motility_source=result.motility_source,
            disclaimer=result.disclaimer,
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi chạy mô phỏng Hunault: {str(e)}",
        )


def _to_domain_input(req: HunaultRequest) -> HunaultInput:
    """Convert API request schema to domain HunaultInput."""
    # Build SpermInput
    sperm = req.sperm_data
    lifestyle = None

    if not sperm.has_test_result and sperm.lifestyle is not None:
        lf = sperm.lifestyle
        lifestyle = LifestyleFactors(
            male_age=lf.male_age,
            smoking=SmokingStatus(lf.smoking.value),
            alcohol=AlcoholConsumption(lf.alcohol.value),
            bmi=lf.bmi,
            exercise=ExerciseFrequency(lf.exercise.value),
            stress=StressLevel(lf.stress.value),
        )

    sperm_input = SpermInput(
        has_test_result=sperm.has_test_result,
        motile_sperm_percent=sperm.motile_sperm_percent,
        lifestyle=lifestyle,
    )

    return HunaultInput(
        female_age=req.female_age,
        duration_months=req.duration_months,
        is_secondary_subfertility=req.is_secondary_subfertility,
        sperm_data=sperm_input,
        is_referred=req.is_referred,
    )


@router.get(
    "/simulation/hunault/info",
    response_model=HunaultModelInfoResponse,
    summary="Thông tin về Hunault Model",
)
async def get_hunault_info() -> HunaultModelInfoResponse:
    """Trả về thông tin mô tả về mô hình Hunault."""
    return HunaultModelInfoResponse(
        model_name="Hunault Model",
        description=(
            "Mô hình Hunault dự đoán xác suất thụ thai tự nhiên (dẫn đến sinh sống) "
            "trong vòng 12 tháng tới cho các cặp vợ chồng đang gặp khó khăn trong "
            "việc thụ thai. Mô hình dựa trên phân tích tổng hợp từ 3 nghiên cứu lớn "
            "về hiếm muộn."
        ),
        version="1.0",
        reference=(
            "Hunault CC, Habbema JD, Eijkemans MJ, Collins JA, Evers JL, "
            "te Velde ER. Two new prediction rules for spontaneous pregnancy "
            "leading to live birth among subfertile couples, based on the "
            "synthesis of three previous models. "
            "Human Reproduction, 2004; 19(9): 2019-2026."
        ),
        input_fields=[
            {
                "field": "female_age",
                "label": "Tuổi phụ nữ",
                "type": "number (18-50)",
                "required": "true",
            },
            {
                "field": "duration_months",
                "label": "Thời gian cố gắng thụ thai (tháng)",
                "type": "integer (1-240)",
                "required": "true",
            },
            {
                "field": "is_secondary_subfertility",
                "label": "Đã từng mang thai trước đây",
                "type": "boolean",
                "required": "false (mặc định: false)",
            },
            {
                "field": "sperm_data",
                "label": "Thông tin tinh dịch đồ hoặc lối sống",
                "type": "object",
                "required": "true",
                "note": (
                    "Nếu chưa xét nghiệm, bấm 'Tôi chưa đi xét nghiệm' "
                    "và trả lời câu hỏi lối sống để ước tính."
                ),
            },
            {
                "field": "is_referred",
                "label": "Được bác sĩ giới thiệu đến chuyên khoa",
                "type": "boolean",
                "required": "false (mặc định: false)",
            },
        ],
        disclaimer=MEDICAL_DISCLAIMER,
    )


@router.get(
    "/simulation/models",
    response_model=SimulationModelListResponse,
    summary="Danh sách mô hình mô phỏng hiện có",
)
async def list_simulation_models() -> SimulationModelListResponse:
    """Trả về danh sách tất cả mô hình mô phỏng."""
    return SimulationModelListResponse(
        models=[
            {
                "id": "hunault",
                "name": "Hunault Model",
                "description": "Dự đoán khả năng thụ thai tự nhiên trong 12 tháng",
                "endpoint": "/api/v1/simulation/hunault",
                "status": "active",
            },
            {
                "id": "unified",
                "name": "Unified Model (New)",
                "description": "Mô phỏng từ bộ câu hỏi 33 câu",
                "endpoint": "/api/v1/simulation/unified",
                "status": "active",
            },
            {
                "id": "sart_ivf",
                "name": "SART IVF Model",
                "description": "Dự đoán tỷ lệ thành công IVF",
                "endpoint": "/api/v1/simulation/unified",
                "status": "testing",
            },
        ]
    )
