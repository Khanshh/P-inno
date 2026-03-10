import json
import os
from fastapi import APIRouter
from typing import List

from app.schemas.feature import FeatureResponse
from app.schemas.home import DailyTipResponse
from app.models.feature import Feature

router = APIRouter()

# Mock data for features
_mock_features: List[Feature] = [
    Feature(
        id="feature-1",
        title="Tìm hiểu kiến thức",
        icon="search",
        description="Khám phá kiến thức về sức khỏe",
        route="/discover",
        order=1,
    ),
    Feature(
        id="feature-2",
        title="Gợi ý bệnh viện",
        icon="medical_services_outlined",
        description="Đánh giá tình trạng sức khỏe của bạn",
        route="/health-assessment",
        order=2,
    ),
    Feature(
        id="feature-3",
        title="Mẹo hôm nay",
        icon="tips_and_updates_outlined",
        description="Những mẹo hữu ích cho sức khỏe",
        route="/daily-tips",
        order=3,
    ),
]

# Load daily tips from JSON file
_daily_tips_path = os.path.join(os.getcwd(), "data", "daily_tips.json")
try:
    with open(_daily_tips_path, "r", encoding="utf-8") as f:
        _mock_daily_tips = json.load(f)
except Exception as e:
    print(f"Error loading daily tips: {e}")
    _mock_daily_tips = []


@router.get("/home/features", response_model=List[FeatureResponse])
async def get_home_features() -> List[FeatureResponse]:
    """
    Get list of home screen features.
    Returns the 3 main feature cards displayed on home screen.
    """
    features = sorted(_mock_features, key=lambda x: x.order)
    return [FeatureResponse(**feature.__dict__) for feature in features]


@router.get("/home/daily-tips", response_model=List[DailyTipResponse])
async def get_daily_tips() -> List[DailyTipResponse]:
    """
    Get list of daily health tips.
    """
    return [DailyTipResponse(**tip) for tip in _mock_daily_tips]
