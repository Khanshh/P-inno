class ApiConfig {
  // Base URL của backend API
  // 
  // Cấu hình theo platform:
  // - Android Emulator: 'http://10.0.2.2:8000'
  // - iOS Simulator: 'http://localhost:8000'
  // - Device thật: 'http://<IP_MÁY_TÍNH>:8000' (ví dụ: 'http://192.168.1.100:8000')
  //192.168.70.36
  // Lưu ý: Backend phải chạy với --host 0.0.0.0 để cho phép kết nối từ thiết bị khác
  // Command: uvicorn app.main:app --reload --host 0.0.0.0
  static const String baseUrl = 'http://192.168.70.36:8000';
  
  // API endpoints
  static const String apiPrefix = '/api/v1';
  
  // Full URLs
  static String get homeFeatures => '$baseUrl$apiPrefix/home/features';
  static String get news => '$baseUrl$apiPrefix/news';
  static String newsDetail(String id) => '$baseUrl$apiPrefix/news/$id';
  static String get discoverMethods => '$baseUrl$apiPrefix/discover/methods';
  static String discoverMethodDetail(String id) => '$baseUrl$apiPrefix/discover/methods/$id';
  static String get infertilityInfo => '$baseUrl$apiPrefix/discover/infertility-info';
  static String get aiChat => '$baseUrl$apiPrefix/ai/chat';
}

