import json
import os
from fastapi import APIRouter

from ai.features.chat_assistant.schemas import ChatRequest, ChatResponse, ChatMessage
from ai.features.chat_assistant.service import generate_chat_reply

router = APIRouter()

_chats_path = os.path.join(os.getcwd(), "data", "chats.json")

def load_chats():
    try:
        if os.path.exists(_chats_path):
            with open(_chats_path, "r", encoding="utf-8") as f:
                return json.load(f)
    except Exception as e:
        print(f"Error loading chats: {e}")
    return {}

def save_chats(chats_data):
    try:
        with open(_chats_path, "w", encoding="utf-8") as f:
            json.dump(chats_data, f, indent=4, ensure_ascii=False)
    except Exception as e:
        print(f"Error saving chats: {e}")

@router.get("/ai/chat/history")
async def get_chat_history(session_id: str):
    """Lấy danh sách chat history dựa theo session_id (tương đương user_id)."""
    chats_data = load_chats()
    history = chats_data.get(session_id, [])
    return {"messages": history}

@router.post("/ai/chat", response_model=ChatResponse)
async def chat_with_ai(payload: ChatRequest) -> ChatResponse:
    """
    Chat endpoint for the AI assistant.

    This route delegates all AI logic to `backend/ai/features/chat_assistant`.
    """
    # Add user context to the backend logic dynamically if user exists
    user_context = "Người dùng chưa rõ thông tin."
    if payload.session_id:
        users_path = os.path.join(os.getcwd(), "data", "users.json")
        try:
            with open(users_path, "r", encoding="utf-8") as f:
                users = json.load(f)
                for u in users:
                    if u["id"] == payload.session_id:
                        gender_str = u.get("gender", "chưa rõ")
                        user_context = f"Thông tin cơ bản của người đang hỏi: Tên {u.get('full_name', '')}, Giới tính: {gender_str}, {u.get('age', 'chưa rõ')} tuổi, Email {u.get('email', '')}, SDT {u.get('phone', '')}. Đặc biệt hãy chú ý xưng hô phù hợp và tư vấn dựa trên thông tin, giới tính này (nếu user là nam mà hỏi có làm IVF được không thì phải phân tích dựa trên thực tế nam giới). "
                        break
        except Exception:
            pass

    # Insert a system message with user context at the beginning
    payload.messages.insert(0, ChatMessage(role="system", content=user_context))
    
    response = await generate_chat_reply(payload)
    
    # Remove the temporarily injected system message so it doesn't get saved twice
    payload.messages.pop(0)

    # Save the updated conversation to the "database"
    if payload.session_id:
        chats_data = load_chats()
        history = chats_data.get(payload.session_id, [])
        
        # Append only the new messages
        history.append({"role": payload.messages[-1].role, "content": payload.messages[-1].content})
        history.append({"role": response.reply.role, "content": response.reply.content})
        
        chats_data[payload.session_id] = history
        save_chats(chats_data)

    return response

