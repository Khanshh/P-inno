# API Endpoints Documentation

## Home Screen Endpoints

### GET `/api/v1/home/features`
Lấy danh sách 3 chức năng trên trang chủ.

**Response:**
```json
[
  {
    "id": "feature-1",
    "title": "Tìm hiểu",
    "icon": "search",
    "description": "Khám phá kiến thức về sức khỏe",
    "route": "/discover",
    "order": 1
  },
  {
    "id": "feature-2",
    "title": "Đánh giá sức khỏe",
    "icon": "monitor_heart_outlined",
    "description": "Đánh giá tình trạng sức khỏe của bạn",
    "route": "/health-assessment",
    "order": 2
  },
  {
    "id": "feature-3",
    "title": "Mẹo hôm nay",
    "icon": "tips_and_updates_outlined",
    "description": "Những mẹo hữu ích cho sức khỏe",
    "route": "/daily-tips",
    "order": 3
  }
]
```

---

## News Endpoints

### GET `/api/v1/news`
Lấy danh sách tin tức y tế với pagination.

**Query Parameters:**
- `page` (int, default: 1): Số trang
- `limit` (int, default: 10, max: 100): Số lượng items mỗi trang
- `category` (string, optional): Lọc theo danh mục
- `search` (string, optional): Tìm kiếm trong title và description

**Response:**
```json
{
  "items": [
    {
      "id": "news-1",
      "title": "Cập nhật hướng dẫn chăm sóc thai kỳ mới",
      "description": "Các bác sĩ khuyến cáo...",
      "category": "Thai kỳ",
      "image_url": null,
      "views": 1200,
      "time": "2 giờ trước",
      "created_at": "2024-01-15T10:00:00"
    }
  ],
  "total": 8,
  "page": 1,
  "limit": 10,
  "has_next": false
}
```

### GET `/api/v1/news/{news_id}`
Lấy chi tiết một bài viết tin tức.

**Response:**
```json
{
  "id": "news-1",
  "title": "Cập nhật hướng dẫn chăm sóc thai kỳ mới",
  "description": "Các bác sĩ khuyến cáo...",
  "content": "Chi tiết về hướng dẫn chăm sóc thai kỳ...",
  "category": "Thai kỳ",
  "image_url": null,
  "views": 1200,
  "created_at": "2024-01-15T10:00:00",
  "updated_at": null
}
```

---

## Discover Endpoints

### GET `/api/v1/discover/methods`
Lấy danh sách các phương pháp hỗ trợ sinh sản.

**Response:**
```json
[
  {
    "id": "method-ivf",
    "title": "IVF",
    "subtitle": "Thụ tinh trong ống nghiệm",
    "icon": "science_outlined",
    "color": "#2196F3",
    "description": "Phương pháp thụ tinh trong ống nghiệm...",
    "order": 1
  },
  {
    "id": "method-iui",
    "title": "IUI",
    "subtitle": "Bơm tinh trùng vào tử cung",
    "icon": "medical_services_outlined",
    "color": "#009688",
    "description": "Phương pháp bơm tinh trùng...",
    "order": 2
  },
  {
    "id": "method-icsi",
    "title": "ICSI",
    "subtitle": "Tiêm tinh trùng vào bào tương",
    "icon": "biotech_outlined",
    "color": "#9C27B0",
    "description": "Kỹ thuật tiêm tinh trùng...",
    "order": 3
  },
  {
    "id": "method-egg-freezing",
    "title": "Đông trứng",
    "subtitle": "Bảo tồn khả năng sinh sản",
    "icon": "ac_unit_outlined",
    "color": "#00BCD4",
    "description": "Kỹ thuật đông lạnh trứng...",
    "order": 4
  }
]
```

### GET `/api/v1/discover/methods/{method_id}`
Lấy chi tiết một phương pháp cụ thể.

**Response:**
```json
{
  "id": "method-ivf",
  "title": "IVF",
  "subtitle": "Thụ tinh trong ống nghiệm",
  "icon": "science_outlined",
  "color": "#2196F3",
  "description": "Phương pháp thụ tinh trong ống nghiệm...",
  "content": "# IVF - Thụ tinh trong ống nghiệm\n\n## Tổng quan\n...",
  "order": 1
}
```

### GET `/api/v1/discover/infertility-info`
Lấy thông tin tổng quan về hiếm muộn.

**Response:**
```json
{
  "id": "infertility-info-1",
  "title": "Tìm hiểu về hiếm muộn",
  "content": "# Hiếm muộn là gì?\n\nHiếm muộn được định nghĩa...",
  "sections": [
    {
      "title": "Định nghĩa",
      "content": "Hiếm muộn là tình trạng không thể có thai..."
    },
    {
      "title": "Nguyên nhân",
      "content": "Có nhiều nguyên nhân dẫn đến hiếm muộn..."
    },
    {
      "title": "Giải pháp",
      "content": "Các phương pháp hỗ trợ sinh sản hiện đại..."
    }
  ]
}
```

---

## Testing

Bạn có thể test các endpoints bằng cách:

1. **Start backend server:**
```bash
cd backend
uvicorn app.main:app --reload
```

2. **Truy cập Swagger UI:**
```
http://localhost:8000/docs
```

3. **Hoặc test bằng curl:**
```bash
# Get home features
curl http://localhost:8000/api/v1/home/features

# Get news with pagination
curl "http://localhost:8000/api/v1/news?page=1&limit=5"

# Get news with search
curl "http://localhost:8000/api/v1/news?search=thai%20kỳ"

# Get discover methods
curl http://localhost:8000/api/v1/discover/methods

# Get specific method
curl http://localhost:8000/api/v1/discover/methods/method-ivf

# Get infertility info
curl http://localhost:8000/api/v1/discover/infertility-info
```

---

## Notes

- Tất cả endpoints này hiện tại là **public** (không cần authentication)
- Dữ liệu đang sử dụng **mock data** trong memory
- Để chuyển sang database, cần:
  1. Setup SQLAlchemy models
  2. Tạo database migrations
  3. Seed initial data
  4. Update routes để query từ database

