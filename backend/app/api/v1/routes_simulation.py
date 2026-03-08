"""
API Routes for Fertility Simulation Models.

Endpoints:
    POST /simulation/hunault          – Chạy mô phỏng Hunault (thụ thai tự nhiên)
    GET  /simulation/hunault/info     – Thông tin về Hunault Model
    GET  /simulation/models           – Danh sách tất cả mô hình
"""

from fastapi import APIRouter, HTTPException

from app.schemas.simulation import (
    HunaultRequest,
    HunaultResponse,
    HunaultModelInfoResponse,
    SimulationModelListResponse,
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

router = APIRouter()


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Helpers – map Pydantic schema → domain dataclass
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


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


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Endpoints
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


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
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi chạy mô phỏng Hunault: {str(e)}",
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
                "id": "sart_ivf",
                "name": "SART IVF Model",
                "description": "Dự đoán tỷ lệ thành công IVF",
                "endpoint": "/api/v1/simulation/sart-ivf",
                "status": "coming_soon",
            },
        ]
    )
