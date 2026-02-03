from dataclasses import dataclass
from datetime import datetime
from typing import Optional


@dataclass
class News:
    id: str
    title: str
    description: str
    content: Optional[str] = None
    summary: Optional[str] = None  # AI-generated summary
    category: Optional[str] = None
    image_url: Optional[str] = None
    views: int = 0
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

