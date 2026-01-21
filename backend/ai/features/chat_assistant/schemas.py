from typing import List, Optional

from pydantic import BaseModel, Field


class ChatMessage(BaseModel):
    role: str = Field(..., description="user | assistant | system")
    content: str = Field(..., description="Nội dung tin nhắn")


class ChatRequest(BaseModel):
    messages: List[ChatMessage] = Field(
        ...,
        description="Lịch sử hội thoại (ít nhất 1 tin nhắn user ở cuối).",
    )
    session_id: Optional[str] = Field(
        default=None,
        description="ID phiên chat (nếu muốn lưu state sau này).",
    )
    use_rag: bool = Field(
        default=False,
        description="Bật RAG để trả lời dựa trên tài liệu có sẵn (news articles, etc.).",
    )


class ChatResponse(BaseModel):
    reply: ChatMessage = Field(..., description="Tin nhắn trả lời của trợ lý AI.")
    session_id: Optional[str] = Field(
        default=None,
        description="ID phiên chat (echo lại hoặc sinh mới).",
    )
    retrieved_context: Optional[List[str]] = Field(
        default=None,
        description="Các đoạn tài liệu được sử dụng để trả lời (chỉ có khi use_rag=True).",
    )


