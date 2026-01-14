from datetime import datetime, timedelta
from fastapi import APIRouter, Query
from typing import List, Optional

from app.schemas.news import NewsResponse, NewsListResponse, NewsDetailResponse
from app.models.news import News

router = APIRouter()

# Mock data for news
_mock_news: List[News] = [
    News(
        id="news-1",
        title="Cập nhật hướng dẫn chăm sóc thai kỳ mới",
        description="Các bác sĩ khuyến cáo lịch khám định kỳ và chế độ dinh dưỡng hợp lý.",
        content="Chi tiết về hướng dẫn chăm sóc thai kỳ...",
        category="Thai kỳ",
        views=1200,
        created_at=datetime.now() - timedelta(hours=2),
    ),
    News(
        id="news-2",
        title="Mẹ bầu cần lưu ý gì mùa lạnh?",
        description="Giữ ấm, bổ sung vitamin và theo dõi chỉ số sức khỏe hằng ngày.",
        content="Những lưu ý quan trọng cho mẹ bầu...",
        category="Sức khỏe",
        views=860,
        created_at=datetime.now() - timedelta(days=1),
    ),
    News(
        id="news-3",
        title="Bài tập nhẹ giúp ngủ ngon hơn",
        description="Thực hiện 10 phút yoga buổi tối giúp mẹ bầu thư giãn cơ thể.",
        content="Hướng dẫn các bài tập yoga...",
        category="Tập luyện",
        views=2300,
        created_at=datetime.now() - timedelta(days=2),
    ),
    News(
        id="news-4",
        title="Tầm quan trọng của giấc ngủ đối với sức khỏe",
        description="Người trưởng thành cần từ 7-9 tiếng ngủ mỗi đêm để phục hồi cơ thể và tinh thần.",
        content="Nghiên cứu về giấc ngủ...",
        category="Sức khỏe",
        views=1800,
        created_at=datetime.now() - timedelta(days=1),
    ),
    News(
        id="news-5",
        title="Khí hậu Việt Nam theo mùa và ảnh hưởng sức khỏe",
        description="Cách phòng tránh các bệnh thường gặp khi thời tiết thay đổi thất thường.",
        content="Phân tích về khí hậu...",
        category="Sức khỏe",
        views=950,
        created_at=datetime.now() - timedelta(hours=12),
    ),
    News(
        id="news-6",
        title="Tập thể dục buổi sáng có tốt không?",
        description="Những lợi ích bất ngờ của việc vận động nhẹ nhàng vào khung giờ vàng buổi sáng.",
        content="Lợi ích của tập thể dục buổi sáng...",
        category="Tập luyện",
        views=1500,
        created_at=datetime.now() - timedelta(hours=5),
    ),
    News(
        id="news-7",
        title="Chế độ ăn Eat Clean cho người bận rộn",
        description="Gợi ý thực đơn nhanh gọn, đầy đủ dinh dưỡng cho dân văn phòng.",
        content="Thực đơn Eat Clean...",
        category="Dinh dưỡng",
        views=5500,
        created_at=datetime.now() - timedelta(days=7),
    ),
    News(
        id="news-8",
        title="Lợi ích của việc uống đủ nước mỗi ngày",
        description="Nước giúp thanh lọc cơ thể, làm đẹp da và hỗ trợ giảm cân hiệu quả.",
        content="Tầm quan trọng của nước...",
        category="Sức khỏe",
        views=800,
        created_at=datetime.now() - timedelta(days=1),
    ),
]


def _format_time_ago(dt: datetime) -> str:
    """Format datetime to Vietnamese time ago string."""
    now = datetime.now()
    diff = now - dt
    
    if diff.days > 0:
        if diff.days == 1:
            return "Hôm qua"
        elif diff.days < 7:
            return f"{diff.days} ngày trước"
        elif diff.days < 30:
            weeks = diff.days // 7
            return f"{weeks} tuần trước"
        else:
            months = diff.days // 30
            return f"{months} tháng trước"
    elif diff.seconds >= 3600:
        hours = diff.seconds // 3600
        return f"{hours} giờ trước"
    elif diff.seconds >= 60:
        minutes = diff.seconds // 60
        return f"{minutes} phút trước"
    else:
        return "Vừa xong"


def _format_views(views: int) -> str:
    """Format views count."""
    if views >= 1000:
        return f"{views / 1000:.1f}k".replace(".0", "")
    return str(views)


@router.get("/news", response_model=NewsListResponse)
async def get_news(
    page: int = Query(1, ge=1, description="Page number"),
    limit: int = Query(10, ge=1, le=100, description="Items per page"),
    category: Optional[str] = Query(None, description="Filter by category"),
    search: Optional[str] = Query(None, description="Search in title and description"),
) -> NewsListResponse:
    """
    Get paginated list of news articles.
    Supports filtering by category and searching.
    """
    # Filter news
    filtered_news = _mock_news.copy()
    
    if category:
        filtered_news = [n for n in filtered_news if n.category == category]
    
    if search:
        search_lower = search.lower()
        filtered_news = [
            n for n in filtered_news
            if search_lower in n.title.lower() or search_lower in n.description.lower()
        ]
    
    # Sort by created_at descending
    filtered_news.sort(key=lambda x: x.created_at or datetime.min, reverse=True)
    
    # Pagination
    total = len(filtered_news)
    start = (page - 1) * limit
    end = start + limit
    paginated_news = filtered_news[start:end]
    
    # Convert to response format
    news_items = [
        NewsResponse(
            id=n.id,
            title=n.title,
            description=n.description,
            category=n.category,
            image_url=n.image_url,
            views=n.views,
            time=_format_time_ago(n.created_at) if n.created_at else "Không xác định",
            created_at=n.created_at,
        )
        for n in paginated_news
    ]
    
    return NewsListResponse(
        items=news_items,
        total=total,
        page=page,
        limit=limit,
        has_next=end < total,
    )


@router.get("/news/{news_id}", response_model=NewsDetailResponse)
async def get_news_detail(news_id: str) -> NewsDetailResponse:
    """
    Get detailed information about a specific news article.
    """
    news = next((n for n in _mock_news if n.id == news_id), None)
    
    if not news:
        from fastapi import HTTPException, status
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"News with id {news_id} not found",
        )
    
    return NewsDetailResponse(
        id=news.id,
        title=news.title,
        description=news.description,
        content=news.content,
        category=news.category,
        image_url=news.image_url,
        views=news.views,
        created_at=news.created_at,
        updated_at=news.updated_at,
    )

