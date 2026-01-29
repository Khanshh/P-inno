from fastapi import APIRouter
from typing import List

from app.schemas.notification import NotificationResponse

router = APIRouter()

# Mock data for notifications
_mock_notifications = [
    {
        "id": "1",
        "icon": "calendar_today",
        "icon_color": "#4CAF50",
        "title": "Lịch khám thai tuần này",
        "description": "Bạn có lịch khám thai vào thứ 3, 15/01/2024 lúc 9:00",
        "time": "5 phút trước",
        "is_read": False,
    },
    {
        "id": "2",
        "icon": "medical_services",
        "icon_color": "#2196F3",
        "title": "Kết quả xét nghiệm mới",
        "description": "Kết quả xét nghiệm máu của bạn đã có sẵn",
        "time": "1 giờ trước",
        "is_read": False,
    },
    {
        "id": "3",
        "icon": "chat_bubble",
        "icon_color": "#FFFF9800",
        "title": "Tin nhắn từ bác sĩ",
        "description": "Bác sĩ Nguyễn Văn A đã gửi cho bạn một tin nhắn",
        "time": "2 giờ trước",
        "is_read": True,
    },
    {
        "id": "4",
        "icon": "notifications_active",
        "icon_color": "#9C27B0",
        "title": "Nhắc nhở uống thuốc",
        "description": "Đã đến giờ uống vitamin D và sắt",
        "time": "3 giờ trước",
        "is_read": True,
    },
    {
        "id": "5",
        "icon": "info",
        "icon_color": "#607D8B",
        "title": "Cập nhật ứng dụng",
        "description": "Phiên bản mới của ứng dụng đã có sẵn",
        "time": "Hôm qua",
        "is_read": True,
    },
    {
        "id": "6",
        "icon": "local_hospital",
        "icon_color": "#E91E63",
        "title": "Lịch tiêm phòng",
        "description": "Nhắc nhở: Tiêm phòng cúm trong tuần này",
        "time": "2 ngày trước",
        "is_read": True,
    },
]

@router.get("/notifications", response_model=List[NotificationResponse])
async def get_notifications() -> List[NotificationResponse]:
    """
    Get list of notifications for the current user.
    """
    return [NotificationResponse(**n) for n in _mock_notifications]
