import json
import os
from fastapi import APIRouter
from typing import List

from app.schemas.notification import NotificationResponse

router = APIRouter()

# Load notifications from JSON file
_notifications_path = os.path.join(os.getcwd(), "data", "notifications.json")
try:
    with open(_notifications_path, "r", encoding="utf-8") as f:
        _mock_notifications = json.load(f)
except Exception as e:
    print(f"Error loading notifications: {e}")
    _mock_notifications = []

@router.get("/notifications", response_model=List[NotificationResponse])
async def get_notifications() -> List[NotificationResponse]:
    """
    Get list of notifications for the current user.
    """
    return [NotificationResponse(**n) for n in _mock_notifications]
