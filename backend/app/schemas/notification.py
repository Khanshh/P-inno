from pydantic import BaseModel
from typing import Optional

class NotificationResponse(BaseModel):
    id: str
    icon: str
    icon_color: str
    title: str
    description: str
    time: str
    is_read: bool

    class Config:
        from_attributes = True
