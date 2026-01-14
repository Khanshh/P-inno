from fastapi import APIRouter, Depends, HTTPException, Header, status

from app.core.config import settings
from app.schemas.user import UserProfile


router = APIRouter()


def _get_current_user(authorization: str = Header(default="")) -> UserProfile:
    """Very simple token check using a static mock token."""
    prefix = "Bearer "
    if not authorization.startswith(prefix):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing Authorization header.",
        )

    token = authorization[len(prefix) :]
    if token != settings.MOCK_ACCESS_TOKEN:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token.",
        )

    # Return a mock user profile
    return UserProfile(
        username="mockuser",
        full_name="Nguyễn Thị A",
        patient_code="BN0001",
        email="patient@example.com",
        phone="+84 912 345 678",
        age=32,
        address="Hà Nội, Việt Nam",
    )


@router.get("/profile/me", response_model=UserProfile)
async def get_my_profile(current_user: UserProfile = Depends(_get_current_user)) -> UserProfile:
    """
    Return the current logged-in user profile (mock data).
    """
    return current_user



