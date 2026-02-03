from fastapi import Header, HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import Optional

from app.core.config import settings

# Security scheme for Swagger UI
security = HTTPBearer()


async def get_current_user(authorization: Optional[str] = Header(None)) -> dict:
    """
    Extract user information from Authorization header.
    
    For now, this is a mock implementation that checks the token
    and returns mock user data based on the token.
    
    In a real implementation, you would:
    1. Extract the token from the Authorization header
    2. Verify and decode the JWT token
    3. Extract user info from the token payload
    """
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Extract token from "Bearer <token>" format
    try:
        scheme, token = authorization.split()
        if scheme.lower() != "bearer":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication scheme",
                headers={"WWW-Authenticate": "Bearer"},
            )
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authorization header format",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Mock token validation
    if token != settings.MOCK_ACCESS_TOKEN:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # In a real app, you would decode the JWT and extract user info
    # For now, we return a mock user (you can extend this to store role in token)
    # Since we're using a single mock token, we'll default to regular user
    # Admin endpoints will need to pass admin token or we check differently
    return {
        "username": "user",
        "full_name": "Nguyễn Thị A",
        "patient_code": "BN0001",
        "role": "user"
    }


async def require_admin(current_user: dict = None) -> dict:
    """
    Dependency to require admin role.
    
    This should be used in combination with get_current_user.
    For now, we'll create a separate check based on a special admin token.
    
    Usage in route:
    @router.post("/admin/endpoint")
    async def admin_only_endpoint(user: dict = Depends(require_admin)):
        ...
    """
    # For this mock implementation, we'll check for a special admin token
    # In a real app, the role would be embedded in the JWT token
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
        )
    
    if current_user.get("role") != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required",
        )
    
    return current_user


async def get_admin_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> dict:
    """
    Combined dependency that gets current user and verifies admin role.
    
    This is a convenience function that combines get_current_user and require_admin.
    Uses HTTPBearer for proper Swagger UI integration.
    """
    if not credentials:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    token = credentials.credentials
    
    # Mock: Check for admin token (in real app, decode JWT and check role)
    # For simplicity, we'll use "admin-token" for admin and "mock-access-token" for users
    if token == "admin-token":
        return {
            "username": "admin",
            "full_name": "Admin User",
            "patient_code": "ADMIN001",
            "role": "admin"
        }
    elif token == settings.MOCK_ACCESS_TOKEN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required",
        )
    else:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
            headers={"WWW-Authenticate": "Bearer"},
        )
