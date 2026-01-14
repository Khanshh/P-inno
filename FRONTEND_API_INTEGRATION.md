# Hướng dẫn tích hợp API vào Flutter Frontend

## Đã tạo

### 1. Dependencies
- ✅ Thêm `http: ^1.2.0` vào `pubspec.yaml`

### 2. Cấu trúc mới
```
lib/
├── core/
│   └── api_config.dart          # Cấu hình API base URL
├── models/
│   ├── feature_model.dart       # Model cho Features
│   ├── news_model.dart          # Model cho News
│   └── discover_model.dart      # Model cho Discover Methods
└── services/
    └── api_service.dart         # Service để gọi API
```

### 3. Đã cập nhật
- ✅ `HomeMainScreen` - Sử dụng API để load features và news

## Cách sử dụng

### 1. Cài đặt dependencies
```bash
cd P-inno
flutter pub get
```

### 2. Cấu hình API URL

Mở file `lib/core/api_config.dart` và cập nhật `baseUrl`:

**Cho Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

**Cho iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:8000';
```

**Cho thiết bị thật (Android/iOS):**
- Tìm IP máy tính của bạn (ví dụ: `192.168.1.100`)
- Cập nhật:
```dart
static const String baseUrl = 'http://192.168.1.100:8000';
```

**Lưu ý:** Đảm bảo máy tính và thiết bị cùng mạng WiFi.

### 3. Start Backend Server

```bash
cd backend
uvicorn app.main:app --reload --host 0.0.0.0
```

**Quan trọng:** Phải dùng `--host 0.0.0.0` để cho phép kết nối từ thiết bị khác.

### 4. Test kết nối

1. **Start backend:**
```bash
cd backend
uvicorn app.main:app --reload --host 0.0.0.0
```

2. **Run Flutter app:**
```bash
cd P-inno
flutter run
```

3. **Kiểm tra:**
   - Mở màn hình HomeMainScreen
   - Features và News sẽ được load từ API
   - Nếu có lỗi, sẽ fallback về mock data

## API Endpoints đã tích hợp

### ✅ HomeMainScreen
- `GET /api/v1/home/features` - Load 3 features
- `GET /api/v1/news?page=1&limit=3` - Load 3 tin tức đầu tiên

### 🔄 Cần tích hợp tiếp
- `NewsScreen` - Load tất cả news với pagination
- `DiscoverScreen` - Load methods và infertility info

## Xử lý lỗi

App đã có error handling:
- Nếu API fail, sẽ fallback về mock data (cho features)
- Hiển thị loading indicator khi đang fetch
- Hiển thị thông báo nếu không có data

## Troubleshooting

### Lỗi: "Connection refused" hoặc "Failed host lookup"

**Nguyên nhân:** Flutter không thể kết nối đến backend.

**Giải pháp:**
1. Kiểm tra backend đã chạy chưa:
```bash
curl http://localhost:8000/health
```

2. Kiểm tra CORS trong backend:
   - Backend đã config CORS cho phép tất cả origins
   - Nếu vẫn lỗi, kiểm tra `app/core/config.py`

3. Kiểm tra URL trong `api_config.dart`:
   - Android Emulator: `http://10.0.2.2:8000`
   - iOS Simulator: `http://localhost:8000`
   - Device thật: `http://<IP_MÁY_TÍNH>:8000`

### Lỗi: "Network is unreachable"

**Nguyên nhân:** Thiết bị và máy tính không cùng mạng.

**Giải pháp:**
- Đảm bảo cả hai cùng WiFi
- Tắt firewall trên máy tính
- Kiểm tra IP máy tính: `ipconfig` (Windows) hoặc `ifconfig` (Mac/Linux)

### Lỗi: "FormatException" khi parse JSON

**Nguyên nhân:** Response từ API không đúng format.

**Giải pháp:**
1. Kiểm tra API response:
```bash
curl http://localhost:8000/api/v1/home/features
```

2. Kiểm tra Swagger UI: `http://localhost:8000/docs`

3. Xem console log trong Flutter để debug

## Next Steps

1. **Tích hợp NewsScreen:**
   - Load news với pagination
   - Implement pull-to-refresh
   - Implement infinite scroll

2. **Tích hợp DiscoverScreen:**
   - Load methods từ API
   - Load infertility info
   - Load method detail

3. **Thêm caching:**
   - Cache API responses
   - Offline support với cached data

4. **Thêm error handling tốt hơn:**
   - Retry mechanism
   - Better error messages
   - Network status checking

