# P-Inno - Ứng dụng Hỗ trợ Sức khỏe Thai sản

Ứng dụng Flutter hỗ trợ sức khỏe thai sản cho cả nam và nữ, được phát triển cho cuộc thi Hackathon.

## Tính năng chính

### 1. Hồ sơ Sức khỏe Cá nhân
- Quản lý thông tin sức khỏe cá nhân
- Theo dõi chu kỳ kinh nguyệt (cho nữ)
- Lưu trữ tiền sử bệnh lý và dị ứng
- Tính toán BMI tự động
- Hỗ trợ cả nam và nữ

### 2. Chatbot Tư vấn Chuyên môn
- Tư vấn về IVF và IUI
- Hướng dẫn theo dõi chu kỳ kinh nguyệt
- Tư vấn về khả năng thụ thai
- Thông tin về sức khỏe sinh sản nam và nữ
- Giao diện chat thân thiện, dễ sử dụng

### 3. Hỗ trợ IVF/IUI
- Thông tin chi tiết về quy trình IVF
- Thông tin chi tiết về quy trình IUI
- Lịch theo dõi với calendar
- Hướng dẫn từng bước cụ thể

### 4. Tính năng Cặp đôi (Couple)
- Kết nối với đối tác
- Chia sẻ ghi chú chung
- Quản lý lịch hẹn chung
- Theo dõi hành trình cùng nhau

## Cài đặt

### Yêu cầu
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Các bước cài đặt

1. Clone repository hoặc tải source code
2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Chạy ứng dụng:
```bash
flutter run
```

## Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── health_profile.dart
│   ├── couple.dart
│   └── chat_message.dart
├── screens/                   # UI Screens
│   ├── home_screen.dart
│   ├── health_profile_screen.dart
│   ├── chatbot_screen.dart
│   ├── ivf_iui_screen.dart
│   └── couple_screen.dart
├── widgets/                   # Reusable widgets
│   └── profile_form.dart
├── providers/                 # State management
│   ├── health_profile_provider.dart
│   └── couple_provider.dart
├── services/                  # Business logic
│   ├── storage_service.dart
│   └── chatbot_service.dart
└── utils/                     # Utilities
```

## Công nghệ sử dụng

- **Flutter**: Framework chính
- **Provider**: State management
- **Shared Preferences**: Local storage
- **Google Fonts**: Typography
- **Table Calendar**: Calendar widget
- **Material Design 3**: UI Design

## Tính năng nổi bật

- ✅ Giao diện hiện đại, thân thiện với người dùng
- ✅ Hỗ trợ cả tiếng Việt
- ✅ Lưu trữ dữ liệu local
- ✅ Tư vấn thông minh với chatbot
- ✅ Theo dõi chu kỳ và lịch
- ✅ Kết nối cặp đôi

## Lưu ý

- Chatbot hiện tại sử dụng responses được định sẵn. Trong production, nên tích hợp với AI service thực tế.
- Dữ liệu được lưu trữ local trên thiết bị.
- Ứng dụng chỉ cung cấp thông tin tham khảo, không thay thế tư vấn y tế chuyên nghiệp.

## Phát triển tiếp theo

- [ ] Tích hợp AI chatbot thực tế
- [ ] Đồng bộ dữ liệu cloud
- [ ] Thông báo nhắc nhở
- [ ] Biểu đồ theo dõi sức khỏe
- [ ] Tích hợp với thiết bị y tế
- [ ] Video hướng dẫn
- [ ] Cộng đồng hỗ trợ

## License

Dự án được phát triển cho mục đích Hackathon.

## Tác giả

Đội ngũ phát triển P-Inno



