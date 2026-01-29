from fastapi import APIRouter
from typing import List

from app.schemas.onboarding import OnboardingPageResponse

router = APIRouter()

# Mock data for onboarding pages
_mock_onboarding_pages = [
    {
        "title": "Chào mừng bạn đến với nơi phép màu bắt đầu.",
        "description": "Từng bước nhỏ cùng bạn hiện thực hóa giấc mơ làm cha mẹ.",
        "icon": "favorite",
        "colors": ["#73C6D9", "#9DD9E8"],
    },
    {
        "title": "Chạm vào mầm sống.",
        "description": "Công nghệ thông minh hỗ trợ các cặp đôi hiếm muộn.",
        "icon": "monitor_heart",
        "colors": ["#5BB8CE", "#73C6D9"],
    },
    {
        "title": "Luôn có chúng tôi bên cạnh.",
        "description": "Kết nối chuyên gia, giải đáp mọi thắc mắc của bạn.",
        "icon": "medical_services",
        "colors": ["#73C6D9", "#B8E6F0"],
    },
    {
        "title": "Hãy để hành trình này trở nên dễ dàng và nhẹ nhàng hơn từ hôm nay.",
        "description": "Đừng chờ đợi thêm, hãy để hy vọng bắt đầu chuyển hóa thành hành động.",
        "icon": "rocket_launch",
        "colors": ["#4DADC2", "#73C6D9"],
    },
]

@router.get("/onboarding", response_model=List[OnboardingPageResponse])
async def get_onboarding_pages() -> List[OnboardingPageResponse]:
    """
    Get list of onboarding pages.
    """
    return [OnboardingPageResponse(**p) for p in _mock_onboarding_pages]
