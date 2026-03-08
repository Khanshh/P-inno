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


class HunaultResponse(BaseModel):
    """
    Response body từ Hunault Model.
    """
    probability_percent: float = Field(
        description="% xác suất thụ thai tự nhiên trong 12 tháng tới"
    )
    risk_level: RiskLevelEnum = Field(
        description="Mức đánh giá: high, moderate, low, very_low"
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


class SimulationModelListResponse(BaseModel):
    """Danh sách các mô hình mô phỏng hiện có."""
    models: List[Dict[str, str]]
