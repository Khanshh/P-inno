"""
Hunault Model – Dự đoán khả năng thụ thai tự nhiên trong 12 tháng.

Dựa trên nghiên cứu:
    Hunault CC, Habbema JD, Eijkemans MJ, Collins JA, Evers JL, te Velde ER.
    "Two new prediction rules for spontaneous pregnancy leading to live birth
    among subfertile couples, based on the synthesis of three previous models."
    Human Reproduction, 2004; 19(9): 2019-2026.

Mô hình sử dụng logistic regression để tính xác suất mang thai tự nhiên
(dẫn đến sinh sống) trong vòng 12 tháng tới cho các cặp vợ chồng hiếm muộn.

⚠️ DISCLAIMER: Đây là công cụ ước tính thống kê, KHÔNG phải chẩn đoán y tế.
   Người dùng cần tham khảo ý kiến bác sĩ chuyên khoa.
"""

import math
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional, List


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Enums for lifestyle / input options
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


class SmokingStatus(str, Enum):
    NONE = "none"           # Không hút thuốc
    LIGHT = "light"         # Hút ít (< 10 điếu/ngày)
    HEAVY = "heavy"         # Hút nhiều (≥ 10 điếu/ngày)


class AlcoholConsumption(str, Enum):
    NONE = "none"           # Không uống
    MODERATE = "moderate"   # Uống vừa phải (≤ 2 ly/tuần)
    HEAVY = "heavy"         # Uống nhiều (> 7 ly/tuần)


class ExerciseFrequency(str, Enum):
    NONE = "none"           # Không tập
    MODERATE = "moderate"   # 1-3 lần/tuần
    REGULAR = "regular"     # ≥ 4 lần/tuần


class StressLevel(str, Enum):
    LOW = "low"
    MODERATE = "moderate"
    HIGH = "high"


class FertilityRiskLevel(str, Enum):
    HIGH = "high"           # Khả năng cao (> 40%)
    MODERATE = "moderate"   # Khả năng trung bình (20-40%)
    LOW = "low"             # Khả năng thấp (10-20%)
    VERY_LOW = "very_low"   # Khả năng rất thấp (< 10%)


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Data Classes
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


@dataclass
class LifestyleFactors:
    """
    Yếu tố lối sống dùng để ước tính chất lượng tinh trùng
    khi người dùng chưa có kết quả xét nghiệm tinh dịch đồ.
    """
    male_age: int = 30
    smoking: SmokingStatus = SmokingStatus.NONE
    alcohol: AlcoholConsumption = AlcoholConsumption.NONE
    bmi: Optional[float] = None
    exercise: ExerciseFrequency = ExerciseFrequency.MODERATE
    stress: StressLevel = StressLevel.MODERATE


@dataclass
class SpermInput:
    """
    Thông tin tinh dịch đồ.

    - Nếu has_test_result=True → dùng motile_sperm_percent (kết quả xét nghiệm thật).
    - Nếu has_test_result=False → ước tính từ lifestyle factors.
    """
    has_test_result: bool = False
    motile_sperm_percent: Optional[float] = None
    lifestyle: Optional[LifestyleFactors] = None


@dataclass
class HunaultInput:
    """Dữ liệu đầu vào cho mô hình Hunault."""
    female_age: float                       # Tuổi của phụ nữ
    duration_months: int                    # Thời gian đã cố gắng thụ thai (tháng)
    is_secondary_subfertility: bool         # Hiếm muộn thứ phát? (đã từng mang thai)
    sperm_data: SpermInput                  # Thông tin tinh trùng
    is_referred: bool = False               # Được bác sĩ giới thiệu đến chuyên khoa?


@dataclass
class HunaultResult:
    """Kết quả dự đoán từ mô hình Hunault."""
    probability_percent: float              # % khả năng thụ thai trong 12 tháng
    risk_level: FertilityRiskLevel          # Mức đánh giá
    interpretation: str                     # Giải thích bằng tiếng Việt
    recommendations: List[str]              # Các khuyến nghị
    factors_summary: dict                   # Tóm tắt các yếu tố đã dùng
    motility_used: float                    # % motility thực tế đã dùng để tính
    motility_source: str                    # "test_result" hoặc "estimated"
    disclaimer: str = ""                    # Cảnh báo y tế


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# WHO baseline & Lifestyle adjustment
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# WHO 2021 – Ngưỡng tham chiếu thấp nhất cho tinh trùng di động tiến tới (PR)
WHO_BASELINE_MOTILITY: float = 40.0  # %


def estimate_motility_from_lifestyle(lifestyle: LifestyleFactors) -> float:
    """
    Ước tính % tinh trùng di động (motility) dựa trên lối sống.

    Bắt đầu từ ngưỡng WHO baseline (40%) và điều chỉnh tăng/giảm
    dựa trên các yếu tố lối sống đã được nghiên cứu.

    Nguồn tham khảo:
    - Sharma R et al., "Lifestyle factors and reproductive health" (2013)
    - Sermondade N et al., "BMI in relation to sperm count" (2013)
    - Li Y et al., "Association between socio-psycho-behavioral factors
      and male semen quality" (2011)

    Returns:
        float: % motility ước tính, giới hạn trong khoảng [5, 80]
    """
    motility = WHO_BASELINE_MOTILITY  # 40%

    # ── Tuổi nam giới ──────────────────────────────────────────────────────
    # Chất lượng tinh trùng giảm dần sau 40 tuổi
    age = lifestyle.male_age
    if age < 30:
        motility += 5.0       # Trẻ, chất lượng tốt
    elif age <= 35:
        motility += 2.0       # Vẫn tốt
    elif age <= 40:
        motility += 0.0       # Bình thường
    elif age <= 45:
        motility -= 5.0       # Bắt đầu giảm
    else:
        motility -= 10.0      # Giảm rõ rệt sau 45

    # ── Hút thuốc ──────────────────────────────────────────────────────────
    # Meta-analysis: hút thuốc giảm motility 10-20% (Sharma 2016)
    if lifestyle.smoking == SmokingStatus.LIGHT:
        motility -= 5.0
    elif lifestyle.smoking == SmokingStatus.HEAVY:
        motility -= 10.0

    # ── Rượu bia ───────────────────────────────────────────────────────────
    # Uống nhiều  → giảm motility (Jensen et al., 2014)
    if lifestyle.alcohol == AlcoholConsumption.MODERATE:
        motility -= 2.0
    elif lifestyle.alcohol == AlcoholConsumption.HEAVY:
        motility -= 8.0

    # ── BMI ─────────────────────────────────────────────────────────────────
    # Béo phì (BMI ≥ 30) → giảm chất lượng tinh trùng (Sermondade 2013)
    if lifestyle.bmi is not None:
        if lifestyle.bmi < 18.5:
            motility -= 3.0   # Thiếu cân
        elif lifestyle.bmi <= 24.9:
            motility += 3.0   # Bình thường, tốt
        elif lifestyle.bmi <= 29.9:
            motility -= 3.0   # Thừa cân
        elif lifestyle.bmi <= 34.9:
            motility -= 7.0   # Béo phì độ 1
        else:
            motility -= 12.0  # Béo phì độ 2+

    # ── Tập thể dục ────────────────────────────────────────────────────────
    # Tập thể dục vừa phải cải thiện chất lượng tinh trùng (Gaskins 2015)
    if lifestyle.exercise == ExerciseFrequency.NONE:
        motility -= 3.0
    elif lifestyle.exercise == ExerciseFrequency.REGULAR:
        motility += 5.0

    # ── Stress ──────────────────────────────────────────────────────────────
    # Stress cao ảnh hưởng tiêu cực (Nargund 2015)
    if lifestyle.stress == StressLevel.MODERATE:
        motility -= 2.0
    elif lifestyle.stress == StressLevel.HIGH:
        motility -= 5.0

    # Clamp to reasonable range [5, 80]
    return max(5.0, min(80.0, round(motility, 1)))


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Core Hunault Model
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


# Hunault 2004 – Model Coefficients
# Model 1: History Only (Pre-test)
# Model 2: History + Semen Analysis (Post-test)
_COEFFICIENTS = {
    "model_1": {
        "intercept": 0.8171,
        "age_linear": -0.4777,
        "age_cubic": 0.0526,
        "duration": -0.1982,
        "secondary": 0.3152,
        "referral": -0.5843,
        "motility": 0.0, # Not used in Model 1
    },
    "model_2": {
        "intercept": 0.4553,
        "age_linear": -0.7138,
        "age_cubic": 0.0614,
        "duration": -0.1494,
        "secondary": 0.2586,
        "referral": -0.4550,
        "motility": 0.0077,
    }
}


def _compute_prognostic_index(
    female_age: float,
    duration_years: float,
    is_secondary: bool,
    motile_sperm_pct: float,
    is_referred: bool,
    has_semen_data: bool = False
) -> float:
    """
    Tính Prognostic Index (PI) theo Hunault 2004.
    Tự động chọn Model 1 (nếu chưa khám) hoặc Model 2 (nếu đã khám).
    """
    model_key = "model_2" if has_semen_data else "model_1"
    c = _COEFFICIENTS[model_key]
    
    age_z = (female_age - 31.0) / 5.0  # Normalized age

    pi = (
        c["intercept"]
        + c["age_linear"] * age_z
        + c["age_cubic"] * (age_z ** 3)
        + c["duration"] * duration_years
        + c["secondary"] * (1.0 if is_secondary else 0.0)
        + c["referral"] * (1.0 if is_referred else 0.0)
    )
    
    # Only add motility factor if using Model 2
    if has_semen_data:
        pi += c["motility"] * motile_sperm_pct
        
    return pi


def _logistic(pi: float) -> float:
    """Logistic sigmoid: P = exp(PI) / (1 + exp(PI))"""
    # Clamp to avoid overflow
    pi_clamped = max(-20.0, min(20.0, pi))
    return math.exp(pi_clamped) / (1.0 + math.exp(pi_clamped))


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Interpretation & Recommendations
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


def _classify_risk(probability: float) -> FertilityRiskLevel:
    """Phân loại mức khả năng dựa trên xác suất."""
    if probability > 0.40:
        return FertilityRiskLevel.HIGH
    elif probability > 0.20:
        return FertilityRiskLevel.MODERATE
    elif probability > 0.10:
        return FertilityRiskLevel.LOW
    else:
        return FertilityRiskLevel.VERY_LOW


def _generate_interpretation(
    probability: float,
    risk_level: FertilityRiskLevel,
    female_age: float,
    duration_months: int,
    motility: float,
    motility_source: str,
) -> str:
    """Tạo giải thích kết quả bằng tiếng Việt."""
    pct = round(probability * 100, 1)
    duration_text = (
        f"{duration_months} tháng" if duration_months < 12
        else f"{duration_months // 12} năm {duration_months % 12} tháng"
        if duration_months % 12 != 0
        else f"{duration_months // 12} năm"
    )

    # Main interpretation
    if risk_level == FertilityRiskLevel.HIGH:
        main = (
            f"Kết quả cho thấy xác suất thụ thai tự nhiên trong 12 tháng tới "
            f"của bạn là khoảng {pct}%. Đây là mức khả năng tương đối cao. "
            f"Tiếp tục theo dõi và duy trì lối sống lành mạnh."
        )
    elif risk_level == FertilityRiskLevel.MODERATE:
        main = (
            f"Xác suất thụ thai tự nhiên trong 12 tháng tới ước tính khoảng {pct}%. "
            f"Đây là mức trung bình. Bạn vẫn có cơ hội thụ thai tự nhiên, "
            f"nhưng nên cân nhắc tham khảo ý kiến bác sĩ."
        )
    elif risk_level == FertilityRiskLevel.LOW:
        main = (
            f"Xác suất thụ thai tự nhiên khoảng {pct}%, ở mức tương đối thấp. "
            f"Bạn nên tham khảo ý kiến bác sĩ chuyên khoa hiếm muộn "
            f"để được tư vấn các phương pháp hỗ trợ thích hợp."
        )
    else:
        main = (
            f"Xác suất thụ thai tự nhiên trong 12 tháng tới ước tính khoảng {pct}%, "
            f"ở mức khá thấp. Bạn nên nhanh chóng gặp bác sĩ chuyên khoa hiếm muộn "
            f"để tìm hiểu các phương pháp hỗ trợ sinh sản (IUI, IVF)."
        )

    # Factor-specific notes
    notes = []
    if female_age >= 38:
        notes.append(
            f"⏳ Ở độ tuổi {int(female_age)}, yếu tố tuổi tác có ảnh hưởng "
            f"đáng kể đến khả năng thụ thai. Thời gian là yếu tố quan trọng."
        )
    if duration_months >= 24:
        notes.append(
            f"📅 Bạn đã cố gắng thụ thai {duration_text}. Thời gian hiếm muộn "
            f"kéo dài làm giảm xác suất thụ thai tự nhiên."
        )
    if motility_source == "estimated":
        notes.append(
            "📋 Kết quả tinh dịch đồ được ước tính từ thông tin lối sống. "
            "Để có kết quả chính xác hơn, bạn nên đi xét nghiệm tinh dịch đồ."
        )
    if motility < 30:
        notes.append(
            f"🔬 Tỷ lệ tinh trùng di động ({motility:.0f}%) thấp hơn ngưỡng "
            f"bình thường (≥ 40% theo WHO). Nên xét nghiệm để xác nhận."
        )

    if notes:
        main += "\n\n" + "\n".join(notes)

    return main


def _generate_recommendations(
    probability: float,
    risk_level: FertilityRiskLevel,
    female_age: float,
    duration_months: int,
    motility: float,
    motility_source: str,
    is_secondary: bool,
) -> List[str]:
    """Tạo danh sách khuyến nghị dựa trên kết quả."""
    recs: List[str] = []

    # Universal recommendations
    recs.append(
        "Duy trì lối sống lành mạnh: ăn uống cân bằng, tập thể dục đều đặn, "
        "hạn chế rượu bia và thuốc lá."
    )
    recs.append(
        "Bổ sung axit folic ít nhất 400mcg/ngày cho phụ nữ."
    )

    # Age-specific
    if female_age >= 35:
        recs.append(
            "Phụ nữ trên 35 tuổi nên gặp bác sĩ sau 6 tháng cố gắng thụ thai "
            "không thành công (thay vì 12 tháng)."
        )

    # Duration-specific
    if duration_months >= 12:
        recs.append(
            "Đã cố gắng trên 12 tháng – nên đặt lịch khám chuyên khoa hiếm muộn "
            "để đánh giá toàn diện."
        )

    # Motility-specific
    if motility_source == "estimated":
        recs.append(
            "Nên đi xét nghiệm tinh dịch đồ (semen analysis) để có thông tin "
            "chính xác hơn về chất lượng tinh trùng."
        )
    elif motility < 40:
        recs.append(
            "Kết quả tinh dịch đồ cho thấy motility dưới ngưỡng WHO. "
            "Nên tái khám và tham khảo bác sĩ nam khoa."
        )

    # Risk-level specific
    if risk_level in (FertilityRiskLevel.LOW, FertilityRiskLevel.VERY_LOW):
        recs.append(
            "Tìm hiểu các phương pháp hỗ trợ sinh sản: IUI (bơm tinh trùng), "
            "IVF (thụ tinh ống nghiệm), ICSI."
        )
        recs.append(
            "Sử dụng công cụ 'Dự đoán thành công IVF' trên ứng dụng "
            "để ước tính tỷ lệ thành công nếu cân nhắc IVF."
        )
    elif risk_level == FertilityRiskLevel.MODERATE:
        recs.append(
            "Theo dõi chu kỳ rụng trứng bằng que thử LH hoặc đo nhiệt độ cơ thể "
            "để tối ưu thời điểm quan hệ."
        )

    # Secondary subfertility note
    if is_secondary:
        recs.append(
            "Hiếm muộn thứ phát (đã từng mang thai) có tiên lượng tốt hơn, "
            "nhưng vẫn nên theo dõi và kiểm tra định kỳ."
        )

    return recs


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Main public API
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MEDICAL_DISCLAIMER = (
    "⚠️ LƯU Ý QUAN TRỌNG: Kết quả này chỉ mang tính chất tham khảo, "
    "được tính toán dựa trên mô hình thống kê (Hunault et al., 2004). "
    "Đây KHÔNG phải là chẩn đoán y tế. Mỗi trường hợp đều có những yếu tố "
    "riêng biệt mà mô hình không thể bao quát hết. "
    "Vui lòng tham khảo ý kiến bác sĩ chuyên khoa hiếm muộn để được "
    "đánh giá và tư vấn chính xác nhất."
)


def predict(input_data: HunaultInput) -> HunaultResult:
    """
    Chạy dự đoán Hunault Model.

    Args:
        input_data: Dữ liệu đầu vào (tuổi, thời gian, tinh trùng, v.v.)

    Returns:
        HunaultResult với xác suất, giải thích, và khuyến nghị.
    """
    # ── Step 1: Xác định motility ──────────────────────────────────────────
    sperm = input_data.sperm_data

    if sperm.has_test_result and sperm.motile_sperm_percent is not None:
        motility = sperm.motile_sperm_percent
        motility_source = "test_result"
    else:
        # Ước tính từ lifestyle factors
        lifestyle = sperm.lifestyle or LifestyleFactors()
        motility = estimate_motility_from_lifestyle(lifestyle)
        motility_source = "estimated"

    # ── Step 2: Tính Prognostic Index ──────────────────────────────────────
    duration_years = input_data.duration_months / 12.0

    pi = _compute_prognostic_index(
        female_age=input_data.female_age,
        duration_years=duration_years,
        is_secondary=input_data.is_secondary_subfertility,
        motile_sperm_pct=motility,
        is_referred=input_data.is_referred,
        has_semen_data=sperm.has_test_result
    )

    # ── Step 3: Tính xác suất ──────────────────────────────────────────────
    probability = _logistic(pi)
    probability_pct = round(probability * 100, 1)

    # ── Step 4: Phân loại & giải thích ─────────────────────────────────────
    risk_level = _classify_risk(probability)

    interpretation = _generate_interpretation(
        probability=probability,
        risk_level=risk_level,
        female_age=input_data.female_age,
        duration_months=input_data.duration_months,
        motility=motility,
        motility_source=motility_source,
    )

    recommendations = _generate_recommendations(
        probability=probability,
        risk_level=risk_level,
        female_age=input_data.female_age,
        duration_months=input_data.duration_months,
        motility=motility,
        motility_source=motility_source,
        is_secondary=input_data.is_secondary_subfertility,
    )

    # ── Step 5: Tạo factors summary ───────────────────────────────────────
    factors_summary = {
        "female_age": {
            "value": input_data.female_age,
            "label": "Tuổi phụ nữ",
            "impact": "negative" if input_data.female_age >= 35 else "neutral",
        },
        "duration": {
            "value": input_data.duration_months,
            "label": "Thời gian cố gắng thụ thai",
            "unit": "tháng",
            "impact": "negative" if input_data.duration_months >= 24 else "neutral",
        },
        "secondary_subfertility": {
            "value": input_data.is_secondary_subfertility,
            "label": "Hiếm muộn thứ phát",
            "impact": "positive" if input_data.is_secondary_subfertility else "neutral",
        },
        "motile_sperm": {
            "value": round(motility, 1),
            "label": "Tinh trùng di động (%)",
            "source": motility_source,
            "impact": "negative" if motility < 40 else "positive" if motility >= 60 else "neutral",
        },
        "referred": {
            "value": input_data.is_referred,
            "label": "Được giới thiệu chuyên khoa",
            "impact": "negative" if input_data.is_referred else "neutral",
        },
    }

    return HunaultResult(
        probability_percent=probability_pct,
        risk_level=risk_level,
        interpretation=interpretation,
        recommendations=recommendations,
        factors_summary=factors_summary,
        motility_used=round(motility, 1),
        motility_source=motility_source,
        disclaimer=MEDICAL_DISCLAIMER,
    )
