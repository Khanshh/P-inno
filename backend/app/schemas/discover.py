from pydantic import BaseModel
from typing import Optional, List


class DiscoverMethodResponse(BaseModel):
    id: str
    title: str
    subtitle: str
    icon: str
    color: str
    description: Optional[str] = None
    order: int

    class Config:
        from_attributes = True


class DiscoverMethodDetailResponse(BaseModel):
    id: str
    title: str
    subtitle: str
    icon: str
    color: str
    description: Optional[str] = None
    content: Optional[str] = None
    order: int

    class Config:
        from_attributes = True


class InfertilityInfoResponse(BaseModel):
    id: str
    title: str
    content: str
    sections: Optional[List[dict]] = None

    class Config:
        from_attributes = True

