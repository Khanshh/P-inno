from pydantic import BaseModel
from typing import Optional


class FeatureResponse(BaseModel):
    id: str
    title: str
    icon: str
    description: Optional[str] = None
    route: Optional[str] = None
    order: int

    class Config:
        from_attributes = True

