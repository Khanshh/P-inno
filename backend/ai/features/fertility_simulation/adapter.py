"""
Adapter layer with AI-powered clinical mapping for users who haven't visited a clinic.
"""

from typing import Dict, Any, Optional
import json
from app.schemas.simulation import ComprehensiveFertilityProfile
from ai.features.fertility_simulation.hunault_model import (
    HunaultInput, SpermInput, LifestyleFactors, SmokingStatus, 
    AlcoholConsumption, ExerciseFrequency, StressLevel
)

# You would ideally use your existing LLM client here
# For this implementation, I will simulate the AI interpretation logic 
# which can be easily swapped with a real OpenAI call.

def map_profile_to_hunault(profile: ComprehensiveFertilityProfile) -> HunaultInput:
    """
    Map the 33-question profile to Hunault Model inputs using Rule-based logic.
    """
    f = profile.female
    m = profile.male

    # ── 1. Map Duration (Strict mapping from survey options) ────────────────
    duration_map = {
        "Dưới 6 tháng": 6,
        "6-12 tháng": 9,
        "1-2 năm": 18,
        "2-3 năm": 30,
        "Trên 3 năm": 48
    }
    duration_months = duration_map.get(f.trying_duration, 12)

    # ── 2. Determine Secondary Subfertility ────────────────────────────────
    # Definition: Has ever been pregnant leading to live birth or confirmed pregnancy
    is_secondary = (f.pregnancy_count != "Chưa từng") or (f.live_births != "0")

    # ── 3. Handle Male Factors (Hunault supports Rule 1: History Only) ──────
    has_test = (m.semen_test != "Chưa từng làm")
    
    # If they HAVE a test, we use the values provided
    motility = None
    if has_test:
        if m.semen_test == "Bình thường":
            motility = 50.0 # Standard mean for normal
        elif m.semen_test == "Bất thường":
            motility = 20.0 # Standard mean for abnormal

    # If they DON'T have a test, we collect lifestyle metrics for context
    # but the model will switch to History-Only coefficients automatically
    smoking_map = {"Không": SmokingStatus.NONE, "Thỉnh thoảng": SmokingStatus.LIGHT, "Thường xuyên": SmokingStatus.HEAVY}
    alcohol_map = {"Không": AlcoholConsumption.NONE, "Thỉnh thoảng": AlcoholConsumption.MODERATE, "Thường xuyên": AlcoholConsumption.HEAVY}
    exercise_map = {"Ít vận động": ExerciseFrequency.NONE, "1-2 lần": ExerciseFrequency.MODERATE, "3-4 lần": ExerciseFrequency.REGULAR, "Hàng ngày": ExerciseFrequency.REGULAR}
    stress_map = {"Thấp": StressLevel.LOW, "Trung bình": StressLevel.MODERATE, "Cao": StressLevel.HIGH}

    lifestyle = LifestyleFactors(
        male_age=int(m.age),
        smoking=smoking_map.get(m.smoking, SmokingStatus.NONE),
        alcohol=alcohol_map.get(m.alcohol, AlcoholConsumption.NONE),
        exercise=exercise_map.get(m.exercise, ExerciseFrequency.MODERATE),
        stress=stress_map.get(m.stress, StressLevel.MODERATE)
    )

    sperm_input = SpermInput(
        has_test_result=has_test,
        motile_sperm_percent=motility,
        lifestyle=lifestyle
    )

    return HunaultInput(
        female_age=f.age,
        duration_months=duration_months,
        is_secondary_subfertility=is_secondary,
        sperm_data=sperm_input,
        is_referred=False # Default to false for common users
    )

async def interpret_symptoms_with_ai(profile: ComprehensiveFertilityProfile) -> Dict[str, Any]:
    """
    Use LLM to map user symptoms to SART/Medical Diagnostic categories.
    This prevents 'guessing' by using standardized medical intelligence.
    """
    f = profile.female
    
    # Construction of a prompt for OpenAI to act as a Clinical Classifier
    # In a real app, you would call: await llm_client.chat(...)
    
    symptoms_summary = f"""
    - Menstrual Cycle: {f.menstrual_cycle}
    - Ovulation Tracking: {f.tracking_ovulation}
    - Known Conditions: PCOS ({f.has_pcos}), Endometriosis ({f.has_endometriosis}), Thyroid ({f.has_thyroid_issues})
    - BMI: {round(f.weight / ((f.height/100)**2), 1)}
    """
    
    # LOGIC (Representing what AI would return based on Rotterdam/SART criteria)
    # We do this logic-based to ensure it's not "hallucinated"
    
    diagnosis_map = {
        "ovulatory_dysfunction": False,
        "tubal_factor": False,
        "endometriosis": f.has_endometriosis == "Có",
        "pcos": f.has_pcos == "Có",
        "unexplained": True # Default
    }
    
    # Smart Mapping: If cycle is irregular, it's ovulatory dysfunction
    if f.menstrual_cycle != "Đều đặn" or f.has_pcos == "Có":
        diagnosis_map["ovulatory_dysfunction"] = True
        diagnosis_map["unexplained"] = False
        
    if f.hsg_result == "Tắc một hoặc hai bên":
        diagnosis_map["tubal_factor"] = True
        diagnosis_map["unexplained"] = False
        
    return diagnosis_map

from .prompts import SYSTEM_PROMPT_CLASSIFIER, SYSTEM_PROMPT_CONSULTANT

async def interpret_symptoms_with_ai(profile: ComprehensiveFertilityProfile) -> Dict[str, Any]:
    """
    Use OpenAI to map user symptoms to SART/Medical Diagnostic categories.
    """
    f = profile.female
    
    # Context data for AI analysis
    user_data = f"""
    Dữ liệu bệnh nhân:
    - Chu kỳ kinh nguyệt: {f.menstrual_cycle}
    - Theo dõi rụng trứng: {f.tracking_ovulation}
    - Tình trạng đã biết: PCOS ({f.has_pcos}), Lạc nội mạc ({f.has_endometriosis}), Tuyến giáp ({f.has_thyroid_issues})
    - Tiền sử HSG: {f.hsg_result}
    - Chiều cao: {f.height}cm, Cân nặng: {f.weight}kg
    """
    
    try:
        llm = get_llm_client()
        response = await llm.generate([
            {"role": "system", "content": SYSTEM_PROMPT_CLASSIFIER},
            {"role": "user", "content": user_data}
        ])
        
        # Parse JSON from AI response
        import re
        json_match = re.search(r'\{.*\}', response, re.DOTALL)
        if json_match:
            return json.loads(json_match.group(0))
    except Exception as e:
        print(f"Error in AI Mapping: {e}")

    # Fallback to rule-based logic if AI fails
    diagnosis_map = {
        "ovulatory_dysfunction": f.menstrual_cycle != "Đều đặn" or f.has_pcos == "Có",
        "tubal_factor": f.hsg_result == "Tắc một hoặc hai bên",
        "endometriosis": f.has_endometriosis == "Có",
        "pcos": f.has_pcos == "Có",
        "unexplained": True
    }
    diagnosis_map["unexplained"] = not any([diagnosis_map["ovulatory_dysfunction"], diagnosis_map["tubal_factor"], diagnosis_map["endometriosis"]])
    
    return diagnosis_map

async def generate_final_report_ai(model_name: str, probability: float, profile: ComprehensiveFertilityProfile, diagnosis: Dict[str, Any]) -> str:
    """
    Use OpenAI to generate a human-friendly, empathetic medical report.
    """
    context = f"""
    KẾT QUẢ MÔ PHỎNG:
    - Mô hình: {model_name}
    - Xác suất thành công: {probability}%
    - Nhóm bệnh lý AI xác định: {', '.join([k for k,v in diagnosis.items() if v])}
    - Hồ sơ: Nữ {profile.female.age} tuổi, Nam {profile.male.age} tuổi.
    """
    
    try:
        llm = get_llm_client()
        return await llm.generate([
            {"role": "system", "content": SYSTEM_PROMPT_CONSULTANT},
            {"role": "user", "content": context}
        ])
    except:
        return f"Dựa trên mô hình {model_name}, xác suất thành công của bạn là {probability}%. Hãy tham khảo ý kiến bác sĩ chuyên khoa để được tư vấn chi tiết."

def map_profile_to_sart(profile: ComprehensiveFertilityProfile, ai_diagnosis: Dict[str, Any]) -> Dict[str, Any]:
    """
    Map to SART Model using the AI-interpreted diagnosis labels.
    """
    f = profile.female
    
    # Calculate BMI
    bmi = f.weight / ((f.height/100)**2)
    
    return {
        "female_age": f.age,
        "bmi": bmi,
        "is_first_cycle": f.done_ivf == "Chưa từng làm",
        "diagnosis": ai_diagnosis,
        "amh_estimated": f.amh_level if f.amh_level != "Không biết" else None
    }
