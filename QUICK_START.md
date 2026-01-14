# 🚀 Hướng dẫn chạy Backend + Frontend

## Bước 1: Chuẩn bị Backend

### 1.1. Kiểm tra Python và dependencies

```bash
# Vào thư mục backend
cd backend

# Kiểm tra Python (cần Python 3.8+)
python --version

# Nếu chưa có virtual environment, tạo mới
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Cài đặt dependencies
pip install -r requirements.txt
```

### 1.2. Start Backend Server

```bash
# Đảm bảo đang ở trong thư mục backend
cd backend

# Activate venv nếu chưa
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Start server với host 0.0.0.0 để cho phép kết nối từ thiết bị khác
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Kết quả mong đợi:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

### 1.3. Test Backend

Mở browser và truy cập:
- **Swagger UI:** http://localhost:8000/docs
- **Health Check:** http://localhost:8000/health
- **API Features:** http://localhost:8000/api/v1/home/features
- **API News:** http://localhost:8000/api/v1/news

---

## Bước 2: Chuẩn bị Frontend

### 2.1. Cài đặt Flutter dependencies

```bash
# Vào thư mục Flutter
cd P-inno

# Cài đặt packages
flutter pub get
```

### 2.2. Cấu hình API URL

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
1. Tìm IP máy tính của bạn:
   - **Windows:** Mở CMD, gõ `ipconfig`, tìm "IPv4 Address"
   - **Mac/Linux:** Mở Terminal, gõ `ifconfig` hoặc `ip addr`
   - Ví dụ: `192.168.1.100`

2. Cập nhật trong `api_config.dart`:
```dart
static const String baseUrl = 'http://192.168.1.100:8000';
```

**Lưu ý:** Đảm bảo máy tính và thiết bị cùng mạng WiFi.

### 2.3. Chạy Flutter App

```bash
# Đảm bảo đang ở trong thư mục P-inno
cd P-inno

# List devices
flutter devices

# Chạy app
flutter run
```

---

## Bước 3: Kiểm tra kết nối

### 3.1. Kiểm tra Backend đang chạy

```bash
# Test health endpoint
curl http://localhost:8000/health

# Test features endpoint
curl http://localhost:8000/api/v1/home/features

# Test news endpoint
curl http://localhost:8000/api/v1/news?page=1&limit=3
```

### 3.2. Kiểm tra trong Flutter App

1. Mở app trên emulator/device
2. Điều hướng đến **HomeMainScreen** (sau onboarding)
3. Kiểm tra:
   - ✅ Features được load từ API (3 cards)
   - ✅ News được load từ API (3 tin đầu tiên)
   - ✅ Có loading indicator khi đang fetch
   - ✅ Không có error messages

---

## Bước 4: Troubleshooting

### ❌ Lỗi: "Connection refused" hoặc "Failed host lookup"

**Nguyên nhân:** Flutter không thể kết nối đến backend.

**Giải pháp:**
1. ✅ Kiểm tra backend đã chạy chưa:
   ```bash
   curl http://localhost:8000/health
   ```

2. ✅ Kiểm tra URL trong `api_config.dart`:
   - Android Emulator: `http://10.0.2.2:8000`
   - iOS Simulator: `http://localhost:8000`
   - Device thật: `http://<IP_MÁY>:8000`

3. ✅ Đảm bảo backend chạy với `--host 0.0.0.0`:
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0
   ```

### ❌ Lỗi: "Network is unreachable"

**Nguyên nhân:** Thiết bị và máy tính không cùng mạng.

**Giải pháp:**
- ✅ Đảm bảo cả hai cùng WiFi
- ✅ Tắt firewall trên máy tính (tạm thời để test)
- ✅ Kiểm tra IP máy tính: `ipconfig` (Windows) hoặc `ifconfig` (Mac/Linux)

### ❌ Lỗi: "FormatException" khi parse JSON

**Nguyên nhân:** Response từ API không đúng format.

**Giải pháp:**
1. ✅ Kiểm tra API response:
   ```bash
   curl http://localhost:8000/api/v1/home/features
   ```

2. ✅ Xem Swagger UI: http://localhost:8000/docs

3. ✅ Check Flutter console logs để debug

### ❌ Backend không start được

**Nguyên nhân:** Port 8000 đã được sử dụng hoặc thiếu dependencies.

**Giải pháp:**
1. ✅ Kiểm tra port:
   ```bash
   # Windows
   netstat -ano | findstr :8000
   
   # Mac/Linux
   lsof -i :8000
   ```

2. ✅ Dùng port khác:
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8001
   ```
   Và cập nhật `api_config.dart` với port mới.

3. ✅ Cài lại dependencies:
   ```bash
   pip install -r requirements.txt
   ```

---

## 📋 Checklist

Trước khi chạy, đảm bảo:

- [ ] Backend dependencies đã cài (`pip install -r requirements.txt`)
- [ ] Backend server đang chạy (`uvicorn app.main:app --reload --host 0.0.0.0`)
- [ ] Backend test thành công (http://localhost:8000/docs)
- [ ] Flutter dependencies đã cài (`flutter pub get`)
- [ ] API URL đã config đúng trong `api_config.dart`
- [ ] Máy tính và thiết bị cùng mạng WiFi (nếu dùng device thật)
- [ ] Firewall không chặn port 8000

---

## 🎯 Quick Commands

### Start Backend:
```bash
cd backend
venv\Scripts\activate  # Windows
# hoặc: source venv/bin/activate  # Mac/Linux
uvicorn app.main:app --reload --host 0.0.0.0
```

### Start Frontend:
```bash
cd P-inno
flutter run
```

### Test Backend:
```bash
curl http://localhost:8000/health
curl http://localhost:8000/api/v1/home/features
```

---

## 📱 Test trên các platform

### Android Emulator
- URL: `http://10.0.2.2:8000`
- Backend: `--host 0.0.0.0`

### iOS Simulator
- URL: `http://localhost:8000`
- Backend: `--host 0.0.0.0`

### Android Device (thật)
- URL: `http://<IP_MÁY>:8000` (ví dụ: `http://192.168.1.100:8000`)
- Backend: `--host 0.0.0.0`
- Cùng WiFi với máy tính

### iOS Device (thật)
- URL: `http://<IP_MÁY>:8000`
- Backend: `--host 0.0.0.0`
- Cùng WiFi với máy tính

---

## 🆘 Cần giúp đỡ?

Nếu gặp lỗi, check:
1. Backend logs trong terminal
2. Flutter console logs
3. Network tab trong browser (test API trực tiếp)
4. Swagger UI: http://localhost:8000/docs

