from fastapi import APIRouter

from ai.features.chat_assistant.schemas import ChatRequest, ChatResponse
from ai.features.chat_assistant.service import generate_chat_reply


router = APIRouter()


@router.post("/ai/chat", response_model=ChatResponse)
async def chat_with_ai(payload: ChatRequest) -> ChatResponse:
    """
    Chat endpoint for the AI assistant.

    This route delegates all AI logic to `backend/ai/features/chat_assistant`.
    """
    return await generate_chat_reply(payload)


