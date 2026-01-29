from pydantic import BaseModel
from typing import List

class AssessmentQuestionResponse(BaseModel):
    id: int
    question: str
    options: List[str]

    class Config:
        from_attributes = True
