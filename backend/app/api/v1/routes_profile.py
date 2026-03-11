import json
import os
from fastapi import APIRouter, Depends, HTTPException, Header, status

from app.core.config import settings
from app.schemas.user import UserProfile


router = APIRouter()


def _get_current_user(authorization: str = Header(default="")) -> UserProfile:
    prefix = "Bearer "
    if not authorization.startswith(prefix):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing Authorization header.",
        )

    token = authorization[len(prefix) :]
    
    users_path = os.path.join(os.getcwd(), "data", "users.json")
    try:
        with open(users_path, "r", encoding="utf-8") as f:
            users_list = json.load(f)
            user = next((u for u in users_list if u["id"] == token), None)
            
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid token or user not found.",
                )
                
            return UserProfile(
                username=user.get("username", ""),
                full_name=user.get("full_name", ""),
                patient_code=user.get("patient_code", ""),
                email=user.get("email", ""),
                phone=user.get("phone", ""),
                age=user.get("age", 0),
                address=user.get("address", ""),
                gender=user.get("gender", ""),
                dob=user.get("dob", ""),
            )
            
    except FileNotFoundError:
        pass

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Internal Error or No Users DB.",
    )


@router.get("/profile/me", response_model=UserProfile)
async def get_my_profile(current_user: UserProfile = Depends(_get_current_user)) -> UserProfile:
    """
    Return the current logged-in user profile (mock data).
    """
    return current_user



