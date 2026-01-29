from fastapi import APIRouter
from typing import List

from app.schemas.health_assessment import AssessmentQuestionResponse

router = APIRouter()

# Mock data for health assessment questions
_mock_questions = [
    {
        "id": 1,
        "question": "Giới tính của bạn?",
        "options": ["Nam", "Nữ"],
    },
    {
        "id": 2,
        "question": "Độ tuổi của bạn?",
        "options": ["< 30", "30 - 35", "35 - 40", "> 40"],
    },
    {
        "id": 3,
        "question": "Thời gian mong con?",
        "options": ["< 6 tháng", "6 - 12 tháng", "> 1 năm"],
    },
    {
        "id": 4,
        "question": "Bạn có tiền sử bệnh lý gì không?",
        "options": ["Đa nang buồng trứng", "Lạc nội mạc tử cung", "Tắc vòi trứng", "Không có"],
    },
    {
        "id": 5,
        "question": "Chu kỳ kinh nguyệt của bạn có đều không?",
        "options": ["Đều", "Không đều", "Vô kinh"],
    },
]

@router.get("/health-assessment/questions", response_model=List[AssessmentQuestionResponse])
async def get_assessment_questions() -> List[AssessmentQuestionResponse]:
    """
    Get list of health assessment questions.
    """
    return [AssessmentQuestionResponse(**q) for q in _mock_questions]
