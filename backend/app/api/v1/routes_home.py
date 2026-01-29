from fastapi import APIRouter
from typing import List

from app.schemas.feature import FeatureResponse
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
        title="Đánh giá sức khỏe",
        icon="monitor_heart_outlined",
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


@router.get("/home/features", response_model=List[FeatureResponse])
async def get_home_features() -> List[FeatureResponse]:
    """
    Get list of home screen features.
    Returns the 3 main feature cards displayed on home screen.
    """
    features = sorted(_mock_features, key=lambda x: x.order)
    return [FeatureResponse(**feature.__dict__) for feature in features]

