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
    """Lấy danh sách chat history dựa theo session_id."""
    chats_data = load_chats()
    # Support both old format (list) and new format (dict)
    session_data = chats_data.get(session_id, [])
    if isinstance(session_data, dict):
        return {"messages": session_data.get("messages", [])}
    return {"messages": session_data}

@router.get("/ai/chat/sessions")
async def get_chat_sessions(user_id: str):
    """Lấy danh sách các phiên chat của một người dùng."""
    chats_data = load_chats()
    sessions = []
    for sid, data in chats_data.items():
        if isinstance(data, dict) and data.get("user_id") == user_id:
            # Lấy tin nhắn đầu tiên của user làm tiêu đề
            messages = data.get("messages", [])
            title = "Cuộc hội thoại mới"
            for msg in messages:
                if msg["role"] == "user":
                    title = msg["content"][:50] + ("..." if len(msg["content"]) > 50 else "")
                    break
            
            sessions.append({
                "session_id": sid,
                "title": title,
                "last_message": messages[-1]["content"] if messages else "",
                "timestamp": data.get("updated_at", "")
            })
    
    # Sort by recent (if timestamp available, though here we just return all)
    return {"sessions": sessions}

@router.post("/ai/chat", response_model=ChatResponse)
async def chat_with_ai(payload: ChatRequest) -> ChatResponse:
    """
    Chat endpoint for the AI assistant.
    """
    # Use user_id if provided, otherwise fallback to session_id (for compatibility)
    target_user_id = payload.user_id or payload.session_id
    
    # Add user context to the backend logic dynamically if user exists
    user_context = "Người dùng chưa rõ thông tin."
    if target_user_id:
        users_path = os.path.join(os.getcwd(), "data", "users.json")
        try:
            with open(users_path, "r", encoding="utf-8") as f:
                users = json.load(f)
                for u in users:
                    if u["id"] == target_user_id:
                        gender_str = u.get("gender", "chưa rõ")
                        user_context = f"Thông tin cơ bản của người đang hỏi: Tên {u.get('full_name', '')}, Giới tính: {gender_str}, {u.get('age', 'chưa rõ')} tuổi, Email {u.get('email', '')}, SDT {u.get('phone', '')}. Đặc biệt hãy chú ý xưng hô phù hợp và tư vấn dựa trên thông tin, giới tính này (nếu user là nam mà hỏi có làm IVF được không thì phải phân tích dựa trên thực tế nam giới). "
                        break
        except Exception:
            pass

    # Insert a system message with user context at the beginning
    payload.messages.insert(0, ChatMessage(role="system", content=user_context))
    
    response = await generate_chat_reply(payload)
    
    # Remove the temporarily injected system message
    payload.messages.pop(0)

    # Save the updated conversation
    if payload.session_id:
        from datetime import datetime
        chats_data = load_chats()
        
        session_id = payload.session_id
        session_data = chats_data.get(session_id, {"user_id": target_user_id, "messages": []})
        
        # If it was in the old list format, convert it
        if isinstance(session_data, list):
            session_data = {"user_id": target_user_id, "messages": session_data}
            
        history = session_data.get("messages", [])
        
        # Append only the new messages
        history.append({"role": payload.messages[-1].role, "content": payload.messages[-1].content})
        history.append({"role": response.reply.role, "content": response.reply.content})
        
        session_data["messages"] = history
        session_data["updated_at"] = datetime.now().isoformat()
        session_data["user_id"] = target_user_id # Ensure user_id is set
        
        chats_data[session_id] = session_data
        save_chats(chats_data)

    return response

