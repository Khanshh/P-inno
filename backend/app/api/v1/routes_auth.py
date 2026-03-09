import json
import os
from fastapi import APIRouter, HTTPException, status

from app.core.config import settings
from app.schemas.auth import LoginRequest, LoginResponse, TokenResponse


router = APIRouter()

# Load users from shared JSON file
_users_path = os.path.join(os.getcwd(), "data", "users.json")
try:
    with open(_users_path, "r", encoding="utf-8") as f:
        _users_list = json.load(f)
except Exception as e:
    print(f"Error loading users for auth: {e}")
    _users_list = []


@router.post("/auth/login", response_model=LoginResponse)
async def login(payload: LoginRequest) -> LoginResponse:
    """
    Login endpoint with role-based authentication.
    
    Users are loaded from data/users.json.
    """
    if not payload.username or not payload.password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username and password are required.",
        )
    
    # Find user by username
    user_data = next(
        (u for u in _users_list if u["username"] == payload.username),
        None,
    )
    
    if not user_data:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password.",
        )
    
    # Check password
    if payload.password != user_data["password"]:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password.",
        )

    token = TokenResponse(
        access_token=settings.ADMIN_ACCESS_TOKEN if user_data["role"] == "admin" else settings.MOCK_ACCESS_TOKEN
    )

    return LoginResponse(
        token=token,
        user_full_name=user_data["full_name"],
        patient_code=user_data["patient_code"],
        role=user_data["role"],
    )

