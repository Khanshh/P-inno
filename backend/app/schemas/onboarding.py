from pydantic import BaseModel
from typing import List

class OnboardingPageResponse(BaseModel):
    title: str
    description: str
    icon: str
    colors: List[str]

    class Config:
        from_attributes = True
