from datetime import datetime, timedelta
from fastapi import APIRouter, Query, Depends, HTTPException, status
from typing import List, Optional
from pydantic import BaseModel

from app.schemas.news import NewsResponse, NewsListResponse, NewsDetailResponse
from app.models.news import News
from app.core.dependencies import get_admin_user

router = APIRouter()

# Mock data for news
_mock_news: List[News] = [
    News(
        id="news-1",
        title="Cập nhật hướng dẫn chăm sóc thai kỳ mới",
        description="Các bác sĩ khuyến cáo lịch khám định kỳ và chế độ dinh dưỡng hợp lý.",
        content="""
**1. Lịch khám thai định kỳ**

Việc khám thai định kỳ là vô cùng quan trọng để theo dõi sự phát triển của thai nhi và sức khỏe của người mẹ. Theo hướng dẫn mới nhất từ Bộ Y tế, mẹ bầu nên thực hiện ít nhất 8 lần khám thai trong suốt thai kỳ, chia làm 3 giai đoạn chính:

*   **3 tháng đầu:** Khám để xác định có thai, vị trí thai, tuổi thai và dự kiến ngày sinh. Thực hiện các xét nghiệm sàng lọc dị tật sớm.
*   **3 tháng giữa:** Theo dõi sự phát triển hình thái của thai nhi, tiêm phòng uốn ván và tầm soát tiểu đường thai kỳ.
*   **3 tháng cuối:** Theo dõi ngôi thai, lượng nước ối, cân nặng thai nhi và chuẩn bị cho cuộc chuyển dạ.

**2. Chế độ dinh dưỡng hợp lý**

Dinh dưỡng đóng vai trò then chốt cho sự phát triển trí não và thể chất của bé. Mẹ bầu cần chú ý:

*   **Bổ sung đủ 4 nhóm chất:** Tinh bột, đạm, chất béo, vitamin và khoáng chất.
*   **Axit Folic:** Rất quan trọng trong 3 tháng đầu để phòng ngừa dị tật ống thần kinh.
*   **Sắt và Canxi:** Giúp ngăn ngừa thiếu máu và hỗ trợ phát triển hệ xương cho bé.
*   **Uống đủ nước:** 2-2.5 lít nước mỗi ngày.

**3. Vận động nhẹ nhàng**

Trừ khi có chỉ định đặc biệt từ bác sĩ, mẹ bầu nên duy trì vận động nhẹ nhàng như đi bộ, yoga hoặc bơi lội để giảm căng thẳng, cải thiện lưu thông máu và dễ sinh hơn.
        """,
        category="Thai kỳ",
        image_url="https://images.unsplash.com/photo-1535402803947-a950d5f71474?auto=format&fit=crop&q=80&w=1000",
        views=1200,
        created_at=datetime.now() - timedelta(hours=2),
    ),
    News(
        id="news-2",
        title="Mẹ bầu cần lưu ý gì mùa lạnh?",
        description="Giữ ấm, bổ sung vitamin và theo dõi chỉ số sức khỏe hằng ngày.",
        content="""
**1. Giữ ấm cơ thể**

Khi nhiệt độ xuống thấp, hệ miễn dịch của mẹ bầu thường nhạy cảm hơn. Việc giữ ấm là ưu tiên hàng đầu:

*   Mặc đủ ấm, đặc biệt là vùng cổ, ngực, bụng và bàn chân.
*   Sử dụng khăn quàng cổ, mũ len khi ra ngoài.
*   Tránh tắm nước quá lạnh hoặc tắm quá lâu.

**2. Tăng cường sức đề kháng**

Mùa lạnh là thời điểm dễ mắc các bệnh đường hô hấp như cúm, cảm lạnh. Mẹ bầu nên:

*   Ăn nhiều trái cây giàu Vitamin C như cam, bưởi, kiwi.
*   Uống nước ấm, có thể thêm chút mật ong hoặc gừng.
*   Tiêm phòng cúm nếu được bác sĩ khuyến nghị.

**3. Chăm sóc làn da**

Không khí hanh khô có thể khiến da mẹ bầu bị nứt nẻ, ngứa ngáy, đặc biệt là vùng bụng đang căng ra. Hãy sử dụng kem dưỡng ẩm an toàn cho bà bầu và uống đủ nước để duy trì độ ẩm cho da.
        """,
        category="Sức khỏe",
        image_url="https://images.unsplash.com/photo-1516483638261-f4dbaf036963?auto=format&fit=crop&q=80&w=1000",
        views=860,
        created_at=datetime.now() - timedelta(days=1),
    ),
    News(
        id="news-3",
        title="Bài tập nhẹ giúp ngủ ngon hơn",
        description="Thực hiện 10 phút yoga buổi tối giúp mẹ bầu thư giãn cơ thể.",
        content="""
**Lợi ích của Yoga đối với giấc ngủ**

Giấc ngủ ngon là "liều thuốc" tự nhiên tốt nhất cho mẹ bầu. Tuy nhiên, sự thay đổi nội tiết tố và sự lớn lên của thai nhi thường gây khó ngủ. Yoga nhẹ nhàng trước khi ngủ giúp:

*   Thư giãn cơ bắp, giảm đau lưng và chuột rút.
*   Điều hòa hơi thở, giảm căng thẳng lo âu.
*   Cải thiện lưu thông máu.

**Một số động tác gợi ý**

1.  **Tư thế con bướm (Butterfly Pose):** Ngồi thẳng lưng, hai lòng bàn chân chạm vào nhau, hai tay nắm lấy bàn chân. Nhịp nhàng nâng hạ hai đầu gối như cánh bướm. Giúp mở khớp háng và thư giãn vùng chậu.
2.  **Tư thế con mèo - con bò (Cat-Cow Pose):** Quỳ gối và chống hai tay xuống sàn. Hít vào, võng lưng xuống, ngẩng mặt lên. Thở ra, cong lưng lên cao, cúi đầu xuống. Giúp giảm đau lưng hiệu quả.
3.  **Tư thế gác chân lên tường:** Nằm ngửa, mông sát tường, hai chân duỗi thẳng lên tường. Giúp giảm phù nề chân và thư giãn tĩnh mạch.

*Lưu ý: Luôn tham khảo ý kiến bác sĩ trước khi bắt đầu bất kỳ chế độ tập luyện nào.*
        """,
        category="Tập luyện",
        image_url="https://images.unsplash.com/photo-1544367563-12123d8965cd?auto=format&fit=crop&q=80&w=1000",
        views=2300,
        created_at=datetime.now() - timedelta(days=2),
    ),
    News(
        id="news-4",
        title="Tầm quan trọng của giấc ngủ đối với sức khỏe",
        description="Người trưởng thành cần từ 7-9 tiếng ngủ mỗi đêm để phục hồi cơ thể và tinh thần.",
        content="""
**Tại sao giấc ngủ lại quan trọng?**

Giấc ngủ không chỉ là thời gian nghỉ ngơi mà còn là lúc cơ thể tự sửa chữa và phục hồi. Đối với phụ nữ mang thai, giấc ngủ càng trở nên quan trọng hơn bao giờ hết vì nó ảnh hưởng trực tiếp đến sức khỏe của cả mẹ và bé.

**Ảnh hưởng của thiếu ngủ:**

*   **Mệt mỏi, kiệt sức:** Làm giảm khả năng tập trung và tăng nguy cơ tai nạn.
*   **Ảnh hưởng tâm lý:** Dễ cáu gắt, trầm cảm, lo âu.
*   **Nguy cơ biến chứng thai kỳ:** Một số nghiên cứu cho thấy thiếu ngủ có thể liên quan đến tăng huyết áp thai kỳ và tiền sản giật.

**Mẹo để có giấc ngủ ngon:**

*   Thiết lập giờ đi ngủ cố định.
*   Tạo không gian ngủ thoải mái, tối và yên tĩnh.
*   Tránh sử dụng thiết bị điện tử trước khi ngủ ít nhất 30 phút.
*   Sử dụng gối ôm dành cho bà bầu để tìm tư thế ngủ thoải mái nhất (thường là nằm nghiêng sang trái).
        """,
        category="Sức khỏe",
        image_url="https://images.unsplash.com/photo-1511295742362-92c96b50484f?auto=format&fit=crop&q=80&w=1000",
        views=1800,
        created_at=datetime.now() - timedelta(days=1),
    ),
    News(
        id="news-5",
        title="Khí hậu Việt Nam theo mùa và ảnh hưởng sức khỏe",
        description="Cách phòng tránh các bệnh thường gặp khi thời tiết thay đổi thất thường.",
        content="""
**Đặc điểm khí hậu và sức khỏe**

Việt Nam có khí hậu nhiệt đới gió mùa, thời tiết thay đổi thất thường là điều kiện thuận lợi cho vi khuẩn và virus phát triển.

*   **Mùa xuân:** Độ ẩm cao (nồm ẩm) dễ gây nấm mốc, dị ứng và các bệnh đường hô hấp.
*   **Mùa hè:** Nắng nóng gay gắt dễ gây say nắng, mất nước và các bệnh tiêu hóa.
*   **Mùa thu - đông:** Giao mùa, nhiệt độ thay đổi đột ngột dễ gây cảm cúm, viêm phổi.

**Biện pháp phòng tránh:**

1.  **Vệ sinh môi trường sống:** Giữ nhà cửa thông thoáng, sạch sẽ, sử dụng máy hút ẩm khi cần thiết.
2.  **Vệ sinh cá nhân:** Rửa tay thường xuyên bằng xà phòng.
3.  **Chế độ ăn uống:** Ăn chín uống sôi, đảm bảo vệ sinh an toàn thực phẩm.
4.  **Trang phục:** Lựa chọn trang phục phù hợp với thời tiết, chất liệu thoáng mát vào mùa hè và giữ ấm vào mùa đông.
        """,
        category="Sức khỏe",
        image_url="https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?auto=format&fit=crop&q=80&w=1000",
        views=950,
        created_at=datetime.now() - timedelta(hours=12),
    ),
    News(
        id="news-6",
        title="Tập thể dục buổi sáng có tốt không?",
        description="Những lợi ích bất ngờ của việc vận động nhẹ nhàng vào khung giờ vàng buổi sáng.",
        content="""
**Khởi động ngày mới tràn đầy năng lượng**

Tập thể dục buổi sáng mang lại nhiều lợi ích tuyệt vời, đặc biệt là cho mẹ bầu:

*   **Tăng cường trao đổi chất:** Giúp cơ thể đốt cháy năng lượng hiệu quả hơn trong suốt cả ngày.
*   **Cải thiện tâm trạng:** Vận động giúp giải phóng Endorphin - hormone hạnh phúc, giúp mẹ bầu cảm thấy vui vẻ, lạc quan.
*   **Hấp thụ Vitamin D:** Tập luyện ngoài trời vào buổi sáng sớm giúp cơ thể hấp thụ Vitamin D tự nhiên, tốt cho xương của mẹ và bé.

**Lưu ý khi tập buổi sáng:**

*   Không tập khi bụng quá đói. Nên ăn nhẹ một chút trước khi tập (ví dụ: một quả chuối hoặc một ly sữa hạt).
*   Khởi động kỹ các khớp trước khi vào bài tập chính.
*   Lắng nghe cơ thể, không tập quá sức. Nếu thấy mệt, khó thở hoặc đau bụng, hãy dừng lại ngay.
        """,
        category="Tập luyện",
        image_url="https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&q=80&w=1000",
        views=1500,
        created_at=datetime.now() - timedelta(hours=5),
    ),
    News(
        id="news-7",
        title="Chế độ ăn Eat Clean cho người bận rộn",
        description="Gợi ý thực đơn nhanh gọn, đầy đủ dinh dưỡng cho dân văn phòng.",
        content="""
**Eat Clean là gì?**

Eat Clean là chế độ ăn ưu tiên thực phẩm tươi sống, nguyên cám và hạn chế tối đa thực phẩm chế biến sẵn, nhiều dầu mỡ, đường và phụ gia. Đây là chế độ ăn rất tốt cho sức khỏe, giúp kiểm soát cân nặng và cung cấp đầy đủ dưỡng chất.

**Nguyên tắc cơ bản:**

*   Ăn đủ các nhóm chất: Protein nạc, tinh bột chuyển hóa chậm (gạo lứt, yến mạch), chất béo tốt (bơ, các loại hạt) và nhiều rau xanh.
*   Chia nhỏ bữa ăn: 5-6 bữa nhỏ mỗi ngày thay vì 3 bữa lớn.
*   Uống nhiều nước.

**Gợi ý thực đơn nhanh gọn:**

*   **Sáng:** Yến mạch ngâm qua đêm với sữa chua và trái cây.
*   **Trưa:** Cơm gạo lứt, ức gà áp chảo và súp lơ luộc.
*   **Chiều:** Một nắm hạt hạnh nhân hoặc óc chó.
*   **Tối:** Cá hồi nướng và salad rau củ.
        """,
        category="Dinh dưỡng",
        image_url="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=1000",
        views=5500,
        created_at=datetime.now() - timedelta(days=7),
    ),
    News(
        id="news-8",
        title="Lợi ích của việc uống đủ nước mỗi ngày",
        description="Nước giúp thanh lọc cơ thể, làm đẹp da và hỗ trợ giảm cân hiệu quả.",
        content="""
**Vai trò của nước đối với cơ thể**

Cơ thể chúng ta chiếm khoảng 70% là nước. Nước tham gia vào hầu hết các quá trình trao đổi chất:

*   Vận chuyển dinh dưỡng và oxy đến các tế bào.
*   Đào thải độc tố qua đường bài tiết.
*   Điều hòa thân nhiệt.
*   Bôi trơn các khớp xương.

**Đối với mẹ bầu:**

Uống đủ nước càng quan trọng hơn để:

*   Duy trì lượng nước ối cần thiết cho thai nhi.
*   Giảm nguy cơ nhiễm trùng đường tiết niệu.
*   Giảm táo bón và trĩ - những vấn đề thường gặp trong thai kỳ.
*   Giảm phù nề.

**Uống bao nhiêu là đủ?**

Mẹ bầu nên uống khoảng 8-10 cốc nước (tương đương 2-2.5 lít) mỗi ngày. Có thể bổ sung thêm từ nước ép trái cây, canh, súp...
        """,
        category="Sức khỏe",
        image_url="https://images.unsplash.com/photo-1548839140-29a749e1cf4d?auto=format&fit=crop&q=80&w=1000",
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


# Admin-only endpoints

class NewsCreateRequest(BaseModel):
    """Schema for creating a new news article."""
    title: str
    description: str
    content: str
    category: str
    image_url: Optional[str] = None


class NewsUpdateRequest(BaseModel):
    """Schema for updating a news article."""
    title: Optional[str] = None
    description: Optional[str] = None
    content: Optional[str] = None
    category: Optional[str] = None
    image_url: Optional[str] = None


@router.post("/news", response_model=NewsDetailResponse, status_code=status.HTTP_201_CREATED)
async def create_news(
    news_data: NewsCreateRequest,
    admin_user: dict = Depends(get_admin_user)
) -> NewsDetailResponse:
    """
    Create a new news article (Admin only).
    
    Requires admin authentication.
    """
    # Generate new ID
    new_id = f"news-{len(_mock_news) + 1}"
    
    # Create new news object
    new_news = News(
        id=new_id,
        title=news_data.title,
        description=news_data.description,
        content=news_data.content,
        category=news_data.category,
        image_url=news_data.image_url,
        views=0,
        created_at=datetime.now(),
    )
    
    # Add to mock database
    _mock_news.append(new_news)
    
    return NewsDetailResponse(
        id=new_news.id,
        title=new_news.title,
        description=new_news.description,
        content=new_news.content,
        category=new_news.category,
        image_url=new_news.image_url,
        views=new_news.views,
        created_at=new_news.created_at,
        updated_at=new_news.updated_at,
    )


@router.put("/news/{news_id}", response_model=NewsDetailResponse)
async def update_news(
    news_id: str,
    news_data: NewsUpdateRequest,
    admin_user: dict = Depends(get_admin_user)
) -> NewsDetailResponse:
    """
    Update an existing news article (Admin only).
    
    Requires admin authentication.
    """
    # Find the news
    news = next((n for n in _mock_news if n.id == news_id), None)
    
    if not news:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"News with id {news_id} not found",
        )
    
    # Update fields if provided
    if news_data.title is not None:
        news.title = news_data.title
    if news_data.description is not None:
        news.description = news_data.description
    if news_data.content is not None:
        news.content = news_data.content
    if news_data.category is not None:
        news.category = news_data.category
    if news_data.image_url is not None:
        news.image_url = news_data.image_url
    
    news.updated_at = datetime.now()
    
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


@router.delete("/news/{news_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_news(
    news_id: str,
    admin_user: dict = Depends(get_admin_user)
):
    """
    Delete a news article (Admin only).
    
    Requires admin authentication.
    """
    global _mock_news
    
    # Find the news
    news = next((n for n in _mock_news if n.id == news_id), None)
    
    if not news:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"News with id {news_id} not found",
        )
    
    # Remove from list
    _mock_news = [n for n in _mock_news if n.id != news_id]
    
    return None

