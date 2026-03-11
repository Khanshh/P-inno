import json
import os
from uuid import uuid4
from fastapi import APIRouter, HTTPException, status

from app.core.config import settings
from app.schemas.auth import LoginRequest, LoginResponse, TokenResponse, RegisterRequest


router = APIRouter()
_users_path = os.path.join(os.getcwd(), "data", "users.json")

def load_users():
    try:
        if os.path.exists(_users_path):
            with open(_users_path, "r", encoding="utf-8") as f:
                return json.load(f)
    except Exception as e:
        print(f"Error loading users: {e}")
    return []

def save_users(users_list):
    try:
        with open(_users_path, "w", encoding="utf-8") as f:
            json.dump(users_list, f, indent=4, ensure_ascii=False)
    except Exception as e:
        print(f"Error saving users: {e}")

@router.post("/auth/register", response_model=LoginResponse)
async def register(payload: RegisterRequest) -> LoginResponse:
    users_list = load_users()
    
    # Check if username exists
    if any(u["username"] == payload.username for u in users_list):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Tên đăng nhập đã tồn tại",
        )
        
    patient_code = f"BN{len(users_list):04d}"
    
    new_user = {
        "id": f"user-{uuid4().hex[:8]}",
        "username": payload.username,
        "password": payload.password,
        "full_name": payload.fullname,
        "patient_code": patient_code,
        "role": "user",
        "email": payload.email,
        "phone": payload.phone,
        "gender": payload.gender,
        "dob": payload.dob,
        "age": 30,
        "address": "Chưa cập nhật"
    }
    
    users_list.append(new_user)
    save_users(users_list)
    
    token = TokenResponse(access_token=new_user["id"])
    
    return LoginResponse(
        token=token,
        user_full_name=new_user["full_name"],
        patient_code=new_user["patient_code"],
        role=new_user["role"],
    )

@router.post("/auth/login", response_model=LoginResponse)
async def login(payload: LoginRequest) -> LoginResponse:
    if not payload.username or not payload.password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Tên đăng nhập và mật khẩu là bắt buộc."
        )
    
    users_list = load_users()
    user_data = next((u for u in users_list if u["username"] == payload.username), None)
    
    if not user_data or payload.password != user_data["password"]:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Sai tên đăng nhập hoặc mật khẩu."
        )

    token = TokenResponse(
        access_token=user_data["id"]
    )

    return LoginResponse(
        token=token,
        user_full_name=user_data["full_name"],
        patient_code=user_data["patient_code"],
        role=user_data["role"],
    )
