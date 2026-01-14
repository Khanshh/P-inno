from fastapi import APIRouter, HTTPException, status

from app.core.config import settings
from app.schemas.auth import LoginRequest, LoginResponse, TokenResponse


router = APIRouter()


@router.post("/auth/login", response_model=LoginResponse)
async def login(payload: LoginRequest) -> LoginResponse:
    """
    Simple mock login endpoint.

    - Accepts any non-empty username/password.
    - Returns a mock access token and basic patient info.
    """
    if not payload.username or not payload.password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username and password are required.",
        )

    token = TokenResponse(access_token=settings.MOCK_ACCESS_TOKEN)
    mock_full_name = "Nguyễn Thị A"
    mock_patient_code = "BN0001"

    return LoginResponse(
        token=token,
        user_full_name=mock_full_name,
        patient_code=mock_patient_code,
    )



