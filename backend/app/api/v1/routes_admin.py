from fastapi import APIRouter, Depends, HTTPException, status
from typing import List
from datetime import datetime
from pydantic import BaseModel

from app.core.dependencies import get_admin_user
from app.schemas.user import UserProfile


router = APIRouter()


# Mock user database
_mock_users = [
    {
        "id": "user-1",
        "username": "admin",
        "full_name": "Admin User",
        "patient_code": "ADMIN001",
        "role": "admin",
        "email": "admin@example.com",
        "phone": "+84 900 000 001",
        "age": 35,
        "address": "Hà Nội, Việt Nam",
    },
    {
        "id": "user-2",
        "username": "user",
        "full_name": "Nguyễn Thị A",
        "patient_code": "BN0001",
        "role": "user",
        "email": "patient@example.com",
        "phone": "+84 912 345 678",
        "age": 28,
        "address": "Hà Nội, Việt Nam",
    },
    {
        "id": "user-3",
        "username": "user2",
        "full_name": "Trần Văn B",
        "patient_code": "BN0002",
        "role": "user",
        "email": "user2@example.com",
        "phone": "+84 912 345 679",
        "age": 32,
        "address": "Hồ Chí Minh, Việt Nam",
    },
]


@router.get("/admin/users", response_model=List[UserProfile])
async def list_users(admin_user: dict = Depends(get_admin_user)) -> List[UserProfile]:
    """
    List all users in the system (Admin only).
    
    Requires admin authentication.
    """
    return [
        UserProfile(
            username=user["username"],
            full_name=user["full_name"],
            patient_code=user["patient_code"],
            role=user["role"],
            email=user.get("email"),
            phone=user.get("phone"),
            age=user.get("age"),
            address=user.get("address"),
        )
        for user in _mock_users
    ]


@router.delete("/admin/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    user_id: str,
    admin_user: dict = Depends(get_admin_user)
):
    """
    Delete a user from the system (Admin only).
    
    Requires admin authentication.
    Cannot delete admin users.
    """
    global _mock_users
    
    # Find the user
    user = next((u for u in _mock_users if u["id"] == user_id), None)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with id {user_id} not found",
        )
    
    # Prevent deleting admin users
    if user["role"] == "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Cannot delete admin users",
        )
    
    # Remove from list
    _mock_users = [u for u in _mock_users if u["id"] != user_id]
    
    return None


class SystemStats(BaseModel):
    """System statistics response."""
    total_users: int
    total_news: int
    total_admin_users: int
    total_regular_users: int
    last_updated: datetime


@router.get("/admin/stats", response_model=SystemStats)
async def get_system_stats(admin_user: dict = Depends(get_admin_user)) -> SystemStats:
    """
    Get system statistics (Admin only).
    
    Requires admin authentication.
    Returns counts of users, news, and other system metrics.
    """
    # Import here to avoid circular dependency
    from app.api.v1.routes_news import _mock_news
    
    total_users = len(_mock_users)
    admin_users = len([u for u in _mock_users if u["role"] == "admin"])
    regular_users = len([u for u in _mock_users if u["role"] == "user"])
    total_news = len(_mock_news)
    
    return SystemStats(
        total_users=total_users,
        total_news=total_news,
        total_admin_users=admin_users,
        total_regular_users=regular_users,
        last_updated=datetime.now(),
    )
