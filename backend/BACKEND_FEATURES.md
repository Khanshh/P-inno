# 🎯 Backend hỗ trợ những gì cho App?

## 📋 Tổng quan

Backend FastAPI hiện tại hỗ trợ **6 nhóm chức năng chính** cho Flutter app:

---

## 1. 🏠 **Home Screen Features** (Trang chủ)

### Endpoint: `GET /api/v1/home/features`

**Chức năng:**
- Cung cấp danh sách 3 chức năng chính trên trang chủ
- Mỗi feature có: title, icon, description, route

**Dữ liệu trả về:**
- ✅ Tìm hiểu (với route `/discover`)
- ✅ Đánh giá sức khỏe (với route `/health-assessment`)
- ✅ Mẹo hôm nay (với route `/daily-tips`)

**Đã tích hợp:** ✅ HomeMainScreen

---

## 2. 📰 **News Management** (Quản lý tin tức)

### Endpoints:
- `GET /api/v1/news` - Lấy danh sách tin tức
- `GET /api/v1/news/{news_id}` - Lấy chi tiết tin tức

**Chức năng:**
- ✅ **Pagination** - Phân trang tin tức (page, limit)
- ✅ **Filter by Category** - Lọc theo danh mục (Thai kỳ, Sức khỏe, Tập luyện, Dinh dưỡng)
- ✅ **Search** - Tìm kiếm trong title và description
- ✅ **Format time** - Format thời gian tiếng Việt ("2 giờ trước", "Hôm qua", ...)
- ✅ **Views tracking** - Theo dõi lượt xem

**Dữ liệu hiện có:**
- 8 bài viết mẫu về sức khỏe thai sản
- Categories: Thai kỳ, Sức khỏe, Tập luyện, Dinh dưỡng

**Đã tích hợp:** ✅ HomeMainScreen (3 tin đầu), ⏳ NewsScreen (chưa tích hợp)

---

## 3. 🔍 **Discover Methods** (Tìm hiểu phương pháp)

### Endpoints:
- `GET /api/v1/discover/methods` - Lấy danh sách phương pháp
- `GET /api/v1/discover/methods/{method_id}` - Lấy chi tiết phương pháp
- `GET /api/v1/discover/infertility-info` - Thông tin về hiếm muộn

**Chức năng:**
- ✅ Cung cấp thông tin về các phương pháp hỗ trợ sinh sản
- ✅ Chi tiết đầy đủ cho mỗi phương pháp (content markdown)

**Dữ liệu hiện có:**
- ✅ **IVF** - Thụ tinh trong ống nghiệm
- ✅ **IUI** - Bơm tinh trùng vào tử cung
- ✅ **ICSI** - Tiêm tinh trùng vào bào tương
- ✅ **Đông trứng** - Bảo tồn khả năng sinh sản
- ✅ Thông tin tổng quan về hiếm muộn

**Đã tích hợp:** ⏳ Chưa tích hợp vào DiscoverScreen

---

## 4. 🔐 **Authentication** (Xác thực)

### Endpoint: `POST /api/v1/auth/login`

**Chức năng:**
- ✅ Đăng nhập với username/password
- ✅ Trả về access token (mock)
- ✅ Trả về thông tin user cơ bản (full_name, patient_code)

**Lưu ý:**
- ⚠️ Hiện tại dùng **mock authentication** (chấp nhận mọi username/password)
- ⚠️ Token là static, chưa có JWT thật
- 🔄 Cần tích hợp database để có authentication thật

**Đã tích hợp:** ⏳ Chưa tích hợp vào LoginScreen

---

## 5. 👤 **User Profile** (Hồ sơ người dùng)

### Endpoint: `GET /api/v1/profile/me`

**Chức năng:**
- ✅ Lấy thông tin profile của user hiện tại
- ✅ Yêu cầu authentication token

**Dữ liệu trả về:**
- Username, Full name, Patient code
- Email, Phone, Age, Address

**Lưu ý:**
- ⚠️ Hiện tại trả về mock data
- 🔄 Cần tích hợp database để lấy data thật

**Đã tích hợp:** ⏳ Chưa tích hợp vào ProfileScreen

---

## 6. 📋 **Medical Records** (Hồ sơ sức khỏe)

### Endpoint: `GET /api/v1/medical-records`

**Chức năng:**
- ✅ Lấy danh sách hồ sơ bệnh án của user
- ✅ Yêu cầu authentication token

**Dữ liệu trả về:**
- ID, Hospital name, Department
- Diagnosis, Visit date, Notes

**Lưu ý:**
- ⚠️ Hiện tại trả về mock data (2 records)
- 🔄 Cần tích hợp database để lấy data thật

**Đã tích hợp:** ⏳ Chưa tích hợp vào MedicalRecordScreen

---

## 📊 Tổng kết

### ✅ Đã tích hợp vào Frontend:
1. ✅ HomeMainScreen - Features và News (3 tin đầu)

### ⏳ Chưa tích hợp:
1. ⏳ NewsScreen - Full news list với pagination
2. ⏳ DiscoverScreen - Methods và Infertility info
3. ⏳ LoginScreen - Authentication
4. ⏳ ProfileScreen - User profile
5. ⏳ MedicalRecordScreen - Medical records

### 🔄 Cần phát triển thêm:
1. 🔄 **Treatment Process** - Quá trình điều trị (chưa có API)
2. 🔄 **Notifications** - Thông báo (chưa có API)
3. 🔄 **Chat AI** - Tích hợp AI service (chưa có API)
4. 🔄 **Database Integration** - Chuyển từ mock data sang database
5. 🔄 **Real Authentication** - JWT tokens thay vì mock
6. 🔄 **File Upload** - Upload ảnh, documents
7. 🔄 **Appointments** - Đặt lịch khám
8. 🔄 **Lab Results** - Kết quả xét nghiệm

---

## 🎯 Ưu tiên phát triển tiếp theo

### Phase 1: Hoàn thiện tích hợp hiện có
1. ✅ Tích hợp NewsScreen với pagination
2. ✅ Tích hợp DiscoverScreen
3. ✅ Tích hợp LoginScreen
4. ✅ Tích hợp ProfileScreen
5. ✅ Tích hợp MedicalRecordScreen

### Phase 2: API mới cần thiết
1. 🔄 Treatment Process API (cho màn "Quá trình điều trị")
2. 🔄 Notifications API
3. 🔄 Chat AI API (hoặc tích hợp AI service)

### Phase 3: Database & Production
1. 🔄 Setup SQLAlchemy + PostgreSQL
2. 🔄 Migrations và seed data
3. 🔄 Real JWT authentication
4. 🔄 Error handling và logging
5. 🔄 API documentation đầy đủ

---

## 📝 Lưu ý quan trọng

### Hiện tại:
- ✅ Tất cả endpoints đều hoạt động với **mock data**
- ✅ Không cần database để test
- ✅ CORS đã được config để cho phép Flutter app kết nối
- ✅ API responses đã được format đúng theo schemas

### Cần cải thiện:
- 🔄 Chuyển sang database thật
- 🔄 Implement authentication thật (JWT)
- 🔄 Thêm validation và error handling tốt hơn
- 🔄 Thêm logging và monitoring
- 🔄 Thêm rate limiting và security

---

## 🚀 Cách sử dụng

Xem file `QUICK_START.md` để biết cách:
1. Start backend server
2. Test các endpoints
3. Tích hợp vào Flutter app
4. Troubleshooting




