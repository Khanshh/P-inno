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


class RegenerateSummariesResponse(BaseModel):
    """Response for regenerate summaries endpoint."""
    total_news: int
    already_had_summary: int
    generated_new: int
    failed: int
    skipped_no_content: int
    message: str


@router.post("/admin/regenerate-summaries", response_model=RegenerateSummariesResponse)
async def regenerate_summaries(
    force: bool = False,
    use_ai: bool = False,
    admin_user: dict = Depends(get_admin_user)
) -> RegenerateSummariesResponse:
    """
    Regenerate summaries for news articles that don't have them (Admin only).
    
    Args:
        force: If True, regenerate even if summary already exists (default: False)
        use_ai: If True, use OpenAI (costs money). If False, use fallback (free) (default: False)
    
    Returns:
        Statistics about the regeneration process
    
    **SAFETY FEATURES:**
    - Only generates for news WITHOUT summary (unless force=True)
    - Default uses FREE fallback (no OpenAI cost)
    - Logs all operations for tracking
    """
    from app.api.v1.routes_news import _mock_news
    from ai.features.news_summarizer import summarize_news_content, generate_fallback_summary
    
    total = len(_mock_news)
    already_had = 0
    generated = 0
    failed = 0
    skipped = 0
    
    print(f"\n{'='*60}")
    print(f"🔄 Starting summary regeneration...")
    print(f"   Mode: {'AI (OpenAI)' if use_ai else 'Fallback (FREE)'}")
    print(f"   Force: {force}")
    print(f"   Total news: {total}")
    print(f"{'='*60}\n")
    
    for news in _mock_news:
        # Skip if already has summary (unless force=True)
        if news.summary and not force:
            already_had += 1
            print(f"⏭️  Skipping '{news.title[:40]}...' - already has summary")
            continue
        
        # Skip if no content
        if not news.content:
            skipped += 1
            print(f"⚠️  Skipping '{news.title[:40]}...' - no content")
            continue
        
        try:
            if use_ai:
                # Use OpenAI (COSTS MONEY)
                print(f"🤖 Generating AI summary and category for: {news.title[:40]}...")
                ai_result = await summarize_news_content(
                    title=news.title,
                    content=news.content,
                )
                if ai_result:
                    summary = ai_result.get("summary")
                    # Update category if it's default or empty
                    if not news.category or news.category == "Sức khỏe" or news.category == "string":
                        news.category = ai_result.get("category", news.category)
                else:
                    summary = None
            else:
                # Use FREE fallback
                print(f"📝 Generating fallback summary for: {news.title[:40]}...")
                summary = await generate_fallback_summary(news.content, max_sentences=2)
            
            if summary:
                news.summary = summary
                generated += 1
                print(f"   ✅ Success (Category: {news.category}): {summary[:50]}...")
            else:
                failed += 1
                print(f"   ❌ Failed to generate summary")
                
        except Exception as e:
            failed += 1
            print(f"   ❌ Error: {e}")
    
    print(f"\n{'='*60}")
    print(f"✅ Summary regeneration complete!")
    print(f"   Total: {total}")
    print(f"   Already had: {already_had}")
    print(f"   Generated: {generated}")
    print(f"   Failed: {failed}")
    print(f"   Skipped: {skipped}")
    print(f"{'='*60}\n")
    
    return RegenerateSummariesResponse(
        total_news=total,
        already_had_summary=already_had,
        generated_new=generated,
        failed=failed,
        skipped_no_content=skipped,
        message=f"Successfully generated {generated} summaries using {'AI' if use_ai else 'fallback'} mode"
    )
