from fastapi import APIRouter, HTTPException, status

from app.core.config import settings
from app.schemas.auth import LoginRequest, LoginResponse, TokenResponse


router = APIRouter()


@router.post("/auth/login", response_model=LoginResponse)
async def login(payload: LoginRequest) -> LoginResponse:
    """
    Mock login endpoint with role-based authentication.
    
    Mock users:
    - admin / admin123 -> role: "admin"
    - user / user123 -> role: "user"
    """
    if not payload.username or not payload.password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username and password are required.",
        )
    
    # Mock user database
    mock_users = {
        "admin": {
            "password": "admin123",
            "full_name": "Admin User",
            "patient_code": "ADMIN001",
            "role": "admin"
        },
        "user": {
            "password": "user123",
            "full_name": "Nguyễn Thị A",
            "patient_code": "BN0001",
            "role": "user"
        }
    }
    
    # Check if user exists
    if payload.username not in mock_users:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password.",
        )
    
    user_data = mock_users[payload.username]
    
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



