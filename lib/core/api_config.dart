class ApiConfig {
  // Base URL của backend API
  // 
  // Cấu hình theo platform:
  // - Android Emulator: 'http://10.0.2.2:8000'
  // - iOS Simulator: 'http://localhost:8000'
  // - Device thật: 'http://<IP_MÁY_TÍNH>:8000' (ví dụ: 'http://192.168.1.100:8000')
  
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // API endpoints
  static const String apiPrefix = '/api/v1';
  
  // Full URLs
  static String get homeFeatures => '$baseUrl$apiPrefix/home/features';
  static String get homeDailyTips => '$baseUrl$apiPrefix/home/daily-tips';
  static String get news => '$baseUrl$apiPrefix/news';
  static String newsDetail(String id) => '$baseUrl$apiPrefix/news/$id';
  static String get discoverMethods => '$baseUrl$apiPrefix/discover/methods';
  static String discoverMethodDetail(String id) => '$baseUrl$apiPrefix/discover/methods/$id';
  static String get infertilityInfo => '$baseUrl$apiPrefix/discover/infertility-info';
  static String get aiChat => '$baseUrl$apiPrefix/ai/chat';
  static String get notifications => '$baseUrl$apiPrefix/notifications';
  static String get healthAssessmentQuestions => '$baseUrl$apiPrefix/health-assessment/questions';
  static String get onboarding => '$baseUrl$apiPrefix/onboarding';
  static String get profileMe => '$baseUrl$apiPrefix/profile/me';
  static String get medicalRecords => '$baseUrl$apiPrefix/medical-records';
}
