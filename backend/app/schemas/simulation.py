"""
Pydantic schemas for Fertility Simulation endpoints.

Covers both Hunault Model and (future) SART IVF Model.
"""

from pydantic import BaseModel, Field, field_validator
from typing import Optional, List, Dict, Any
from enum import Enum


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Enums (mirrored from hunault_model for API layer)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


class SmokingStatusEnum(str, Enum):
    none = "none"
    light = "light"
    heavy = "heavy"


class AlcoholEnum(str, Enum):
    none = "none"
    moderate = "moderate"
    heavy = "heavy"


class ExerciseEnum(str, Enum):
    none = "none"
    moderate = "moderate"
    regular = "regular"


class StressEnum(str, Enum):
    low = "low"
    moderate = "moderate"
    high = "high"


class RiskLevelEnum(str, Enum):
    high = "high"
    moderate = "moderate"
    low = "low"
    very_low = "very_low"


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Request schemas
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


class LifestyleFactorsRequest(BaseModel):
    """
    Yếu tố lối sống – dùng khi người dùng chưa có kết quả tinh dịch đồ.

    Ứng dụng sẽ dựa vào các yếu tố này để ước tính chất lượng tinh trùng.
    """
    male_age: int = Field(
        default=30,
        ge=18, le=70,
        description="Tuổi nam giới (18-70)",
        json_schema_extra={"example": 32},
    )
    smoking: SmokingStatusEnum = Field(
        default=SmokingStatusEnum.none,
        description="Tình trạng hút thuốc: none (không), light (ít), heavy (nhiều)",
    )
    alcohol: AlcoholEnum = Field(
        default=AlcoholEnum.none,
        description="Mức sử dụng rượu bia: none, moderate (vừa), heavy (nhiều)",
    )
    bmi: Optional[float] = Field(
        default=None,
        ge=12.0, le=60.0,
        description="Chỉ số BMI nam giới (nếu biết)",
        json_schema_extra={"example": 24.5},
    )
    exercise: ExerciseEnum = Field(
        default=ExerciseEnum.moderate,
        description="Tần suất tập thể dục: none, moderate (1-3 lần/tuần), regular (≥4 lần/tuần)",
    )
    stress: StressEnum = Field(
        default=StressEnum.moderate,
        description="Mức độ căng thẳng: low, moderate, high",
    )

    class Config:
        json_schema_extra = {
            "example": {
                "male_age": 32,
                "smoking": "none",
                "alcohol": "moderate",
                "bmi": 24.5,
                "exercise": "moderate",
                "stress": "moderate",
            }
        }


class SpermDataRequest(BaseModel):
    """
    Thông tin tinh dịch đồ.

    Nếu has_test_result = true:  dùng motile_sperm_percent (kết quả xét nghiệm).
    Nếu has_test_result = false: dùng lifestyle factors để ước tính.
    """
    has_test_result: bool = Field(
        default=False,
        description="Người dùng đã có kết quả xét nghiệm tinh dịch đồ chưa?",
    )
    motile_sperm_percent: Optional[float] = Field(
        default=None,
        ge=0.0, le=100.0,
        description="% tinh trùng di động (nếu có kết quả xét nghiệm, 0-100)",
        json_schema_extra={"example": 55.0},
    )
    lifestyle: Optional[LifestyleFactorsRequest] = Field(
        default=None,
        description="Yếu tố lối sống (sử dụng khi chưa có kết quả xét nghiệm)",
    )

    @field_validator("motile_sperm_percent")
    @classmethod
    def validate_motility(cls, v, info):
        """Kiểm tra: nếu có kết quả xét nghiệm thì phải cung cấp motility."""
        if info.data.get("has_test_result") and v is None:
            raise ValueError(
                "Khi has_test_result=true, bạn cần cung cấp motile_sperm_percent."
            )
        return v

    class Config:
        json_schema_extra = {
            "examples": [
                {
                    "summary": "Có kết quả xét nghiệm",
                    "value": {
                        "has_test_result": True,
                        "motile_sperm_percent": 55.0,
                    },
                },
                {
                    "summary": "Chưa xét nghiệm – ước tính từ lối sống",
                    "value": {
                        "has_test_result": False,
                        "lifestyle": {
                            "male_age": 35,
                            "smoking": "light",
                            "alcohol": "moderate",
                            "bmi": 27.0,
                            "exercise": "none",
                            "stress": "high",
                        },
                    },
                },
            ]
        }


class HunaultRequest(BaseModel):
    """
    Request body cho Hunault Model – dự đoán khả năng thụ thai tự nhiên.
    """
    female_age: float = Field(
        ...,
        ge=18.0, le=50.0,
        description="Tuổi phụ nữ (18-50)",
        json_schema_extra={"example": 30.0},
    )
    duration_months: int = Field(
        ...,
        ge=1, le=240,
        description="Số tháng đã cố gắng thụ thai",
        json_schema_extra={"example": 18},
    )
    is_secondary_subfertility: bool = Field(
        default=False,
        description=(
            "Hiếm muộn thứ phát? (Bạn đã từng mang thai trước đây chưa? "
            "Nếu đã từng → true)"
        ),
    )
    sperm_data: SpermDataRequest = Field(
        ...,
        description="Thông tin tinh dịch đồ hoặc lối sống để ước tính",
    )
    is_referred: bool = Field(
        default=False,
        description="Bạn có được bác sĩ tuyến dưới giới thiệu đến chuyên khoa hiếm muộn không?",
    )

    class Config:
        json_schema_extra = {
            "example": {
                "female_age": 30,
                "duration_months": 18,
                "is_secondary_subfertility": False,
                "sperm_data": {
                    "has_test_result": False,
                    "lifestyle": {
                        "male_age": 32,
                        "smoking": "none",
                        "alcohol": "moderate",
                        "bmi": 24.5,
                        "exercise": "moderate",
                        "stress": "moderate",
                    },
                },
                "is_referred": False,
            }
        }


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Response schemas
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


class FactorDetail(BaseModel):
    """Chi tiết một yếu tố ảnh hưởng."""
    value: Any
    label: str
    impact: str = Field(description="Mức ảnh hưởng: positive, neutral, negative")
    unit: Optional[str] = None
    source: Optional[str] = None


class PatientGroup(BaseModel):
    """Phân nhóm bệnh nhân để hiển thị thân thiện hơn."""
    name: str
    color: str
    description: str
    icon: str


class HunaultResponse(BaseModel):
    """
    Response body từ Hunault Model.
    """
    probability_percent: float = Field(
        description="% xác suất thụ thai tự nhiên trong 12 tháng tới"
    )
    probability_range: str = Field(
        description="Khoảng xác suất tin cậy (VD: '25% - 40%')"
    )
    risk_level: RiskLevelEnum = Field(
        description="Mức đánh giá: high, moderate, low, very_low"
    )
    patient_group: Optional[PatientGroup] = Field(
        default=None,
        description="Phân nhóm bệnh nhân thân thiện"
    )
    interpretation: str = Field(
        description="Giải thích kết quả chi tiết bằng tiếng Việt"
    )
    recommendations: List[str] = Field(
        description="Danh sách khuyến nghị"
    )
    factors_summary: Dict[str, Any] = Field(
        description="Tóm tắt các yếu tố đã sử dụng và mức ảnh hưởng"
    )
    motility_used: float = Field(
        description="% motility thực tế được sử dụng trong tính toán"
    )
    motility_source: str = Field(
        description="Nguồn motility: 'test_result' hoặc 'estimated'"
    )
    timeline_data: List[dict] = Field(
        description="Mảng xác suất tích lũy 1-24 tháng kèm phân vùng zone"
    )
    break_point: int = Field(
        description="Tháng mà đường cong bắt đầu đi ngang"
    )
    disclaimer: str = Field(
        description="Cảnh báo y tế bắt buộc"
    )

    class Config:
        from_attributes = True


class HunaultModelInfoResponse(BaseModel):
    """Thông tin mô tả về Hunault Model."""
    model_name: str
    description: str
    version: str
    reference: str
    input_fields: List[Dict[str, str]]
    disclaimer: str


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Comprehensive Profile (Common Survey)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class FrequencyEnum(str, Enum):
    none = "Không"
    sometimes = "Thỉnh thoảng"
    frequently = "Thường xuyên"

class ExerciseFreqEnum(str, Enum):
    none = "Ít vận động"
    light = "1-2 lần"
    moderate = "3-4 lần"
    heavy = "Hàng ngày"

class FemaleProfile(BaseModel):
    age: float = Field(..., description="Câu 1: Tuổi")
    height: float = Field(..., description="Câu 2: Chiều cao (cm)")
    weight: float = Field(..., description="Câu 3: Cân nặng (kg)")
    trying_duration: str = Field(..., description="Câu 4: Thời gian cố gắng")
    pregnancy_count: str = Field(..., description="Câu 5: Số lần mang thai")
    live_births: str = Field(..., description="Câu 6: Số lần sinh con đủ tháng")
    miscarriages: str = Field(..., description="Câu 7: Số lần sảy thai")
    done_ivf: str = Field(..., description="Câu 8: Đã từng làm IVF chưa")
    menstrual_cycle: str = Field(..., description="Câu 9: Chu kỳ kinh nguyệt")
    tracking_ovulation: str = Field(..., description="Câu 10: Theo dõi rụng trứng")
    amh_level: str = Field(..., description="Câu 11: Chỉ số AMH")
    afc_count: str = Field(..., description="Câu 12: Số lượng nang noãn AFC")
    hsg_result: str = Field(..., description="Câu 13: Chụp tử cung vòi trứng HSG")
    has_pcos: str = Field(..., description="Câu 14: Hội chứng buồng trứng đa nang")
    has_endometriosis: str = Field(..., description="Câu 15: Lạc nội mạc tử cung")
    has_thyroid_issues: str = Field(..., description="Câu 16: Vấn đề tuyến giáp")
    smoking: str = Field(..., description="Câu 17: Hút thuốc")
    alcohol: str = Field(..., description="Câu 18: Rượu bia")
    exercise: str = Field(..., description="Câu 19: Tập thể dục")
    stress: str = Field(..., description="Câu 20: Mức độ stress")

class MaleProfile(BaseModel):
    age: float = Field(..., description="Câu 1: Tuổi")
    has_children: str = Field(..., description="Câu 2: Đã từng có con chưa")
    semen_test: str = Field(..., description="Câu 3: Xét nghiệm tinh dịch đồ")
    testosterone: str = Field(..., description="Câu 4: Chỉ số testosterone")
    testicular_issues: str = Field(..., description="Câu 5: Vấn đề tinh hoàn")
    varicocele: str = Field(..., description="Câu 6: Giãn tĩnh mạch thừng tinh")
    erectile_dysfunction: str = Field(..., description="Câu 7: Rối loạn cương dương")
    ejaculation_issues: str = Field(..., description="Câu 8: Vấn đề xuất tinh")
    smoking: str = Field(..., description="Câu 9: Hút thuốc")
    alcohol: str = Field(..., description="Câu 10: Rượu bia")
    exercise: str = Field(..., description="Câu 11: Tập thể dục")
    environment: str = Field(..., description="Câu 12: Môi trường làm việc")
    stress: str = Field(..., description="Câu 13: Mức độ stress")

class ComprehensiveFertilityProfile(BaseModel):
    """
    Hồ sơ sinh sản toàn diện gom 33 câu hỏi từ Frontend.
    Được dùng làm 'Single Source of Truth' cho mọi mô hình AI.
    """
    female: FemaleProfile
    male: MaleProfile

class UnifiedSimulationRequest(BaseModel):
    """
    Yêu cầu mô phỏng hợp nhất. 
    Frontend chỉ cần gửi profile này lên, backend sẽ tự 'nhặt' dữ liệu 
    để chạy model tương ứng.
    """
    model_id: str = Field(..., description="ID của model muốn chạy (hunault hoặc sart_ivf)")
    user_id: str = Field(default="", description="ID của user")
    profile: ComprehensiveFertilityProfile

class SimulationModelListResponse(BaseModel):
    """Danh sách các mô hình mô phỏng hiện có."""
    models: List[Dict[str, str]]
