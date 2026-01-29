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

# Mock data for daily tips
_mock_daily_tips = [
    {
        "title": "Uống Đủ Nước Mỗi Ngày",
        "content": "Uống ít nhất 8 cốc nước mỗi ngày giúp cơ thể duy trì độ ẩm, hỗ trợ tiêu hóa và làm đẹp da."
    },
    {
        "title": "Ngủ Đủ Giấc",
        "content": "Ngủ 7-8 tiếng mỗi đêm giúp cơ thể phục hồi năng lượng, tăng cường hệ miễn dịch và cải thiện trí nhớ."
    },
    {
        "title": "Ăn Nhiều Rau Xanh",
        "content": "Bổ sung rau xanh vào bữa ăn hàng ngày giúp cung cấp vitamin, khoáng chất và chất xơ cần thiết cho cơ thể."
    },
    {
        "title": "Tập Thể Dục Đều Đặn",
        "content": "Dành ít nhất 30 phút mỗi ngày để vận động nhẹ nhàng như đi bộ, yoga giúp cải thiện sức khỏe tim mạch."
    },
    {
        "title": "Giảm Stress",
        "content": "Dành thời gian thư giãn, nghe nhạc hoặc thiền để giảm căng thẳng và cải thiện tinh thần."
    },
    {
        "title": "Hạn Chế Đường",
        "content": "Giảm lượng đường tiêu thụ giúp giảm nguy cơ béo phì, tiểu đường và các bệnh tim mạch."
    },
    {
        "title": "Khám Sức Khỏe Định Kỳ",
        "content": "Thăm khám bác sĩ định kỳ 6 tháng/lần để phát hiện sớm các vấn đề sức khỏe tiềm ẩn."
    },
]


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
