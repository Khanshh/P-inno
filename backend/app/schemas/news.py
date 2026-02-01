from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class NewsBase(BaseModel):
    title: str
    description: str
    category: Optional[str] = None
    image_url: Optional[str] = None


class NewsResponse(NewsBase):
    id: str
    views: int
    time: str  # Formatted time like "2 giờ trước"
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class NewsDetailResponse(NewsBase):
    id: str
    content: Optional[str] = None
    views: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class NewsListResponse(BaseModel):
    items: list[NewsResponse]
    total: int
    page: int
    limit: int
    has_next: bool


class NewsCreateRequest(BaseModel):
    """Schema for creating a new news article."""
    title: str
    description: str
    content: str
    category: str
    image_url: Optional[str] = None


class NewsUpdateRequest(BaseModel):
    """Schema for updating a news article."""
    title: Optional[str] = None
    description: Optional[str] = None
    content: Optional[str] = None
    category: Optional[str] = None
    image_url: Optional[str] = None

