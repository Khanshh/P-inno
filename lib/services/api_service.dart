import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/feature_model.dart';
import '../models/news_model.dart';
import '../models/discover_model.dart';
import '../models/notification_model.dart';
import '../models/home_model.dart';
import '../models/health_assessment_model.dart';
import '../models/onboarding_model.dart';
import '../models/user_model.dart';
import '../models/medical_record_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<FeatureModel>> getHomeFeatures() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.homeFeatures));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => FeatureModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load features: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching features: $e');
    }
  }

  Future<List<DailyTipModel>> getDailyTips() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.homeDailyTips));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => DailyTipModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load daily tips: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching daily tips: $e');
    }
  }

  Future<NewsListResponse> getNews({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.news).replace(queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      });

      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        return NewsListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<NewsModel> getNewsDetail(String newsId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.news}/$newsId'),
      );

      if (response.statusCode == 200) {
        return NewsModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load news detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news detail: $e');
    }
  }

  Future<List<DiscoverMethodModel>> getDiscoverMethods() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.discoverMethods));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((json) => DiscoverMethodModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load methods: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching methods: $e');
    }
  }

  Future<DiscoverMethodDetailModel> getDiscoverMethodDetail(String methodId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.discoverMethodDetail(methodId)),
      );
      
      if (response.statusCode == 200) {
        return DiscoverMethodDetailModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load method detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching method detail: $e');
    }
  }

  Future<InfertilityInfoModel> getInfertilityInfo() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.infertilityInfo));
      
      if (response.statusCode == 200) {
        return InfertilityInfoModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load infertility info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching infertility info: $e');
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.notifications));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<List<AssessmentQuestionModel>> getAssessmentQuestions() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.healthAssessmentQuestions));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => AssessmentQuestionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load assessment questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching assessment questions: $e');
    }
  }

  Future<List<OnboardingPageModel>> getOnboardingPages() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.onboarding));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => OnboardingPageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load onboarding pages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching onboarding pages: $e');
    }
  }

  Future<UserProfileModel> getMyProfile() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.profileMe),
        headers: {
          'Authorization': 'Bearer mock-access-token',
        },
      );
      
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load profile: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: \$e');
    }
  }

  Future<List<MedicalRecordModel>> getMedicalRecords() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.medicalRecords),
        headers: {
          'Authorization': 'Bearer mock-access-token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => MedicalRecordModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medical records: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching medical records: \$e');
    }
  }

  /// Register a new user via POST /api/v1/auth/register
  Future<Map<String, dynamic>> registerPatient(Map<String, dynamic> patientData) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.authRegister),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fullname': patientData['fullName'] ?? '',
          'username': patientData['email'] ?? patientData['phone'] ?? '',
          'password': patientData['password'] ?? '123456',
          'phone': patientData['phone'] ?? '',
          'dob': patientData['dob'] ?? '',
          'email': patientData['email'] ?? '',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final body = json.decode(response.body);
        throw Exception(body['detail'] ?? 'Failed to register patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registering patient: $e');
    }
  }

  /// Get all registered patients via GET /api/v1/patients
  Future<List<Map<String, dynamic>>> getPatients() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.patients));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching patients: $e');
    }
  }

  /// Login via POST /api/v1/auth/login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.authLogin),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final body = json.decode(response.body);
        throw Exception(body['detail'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// Run unified simulation via POST /api/v1/simulation/unified
  Future<Map<String, dynamic>> runSimulation(String modelId, Map<String, dynamic> femaleData, Map<String, dynamic> maleData) async {
    try {
      final requestBody = {
        "model_id": modelId,
        "profile": {
          "female": femaleData,
          "male": maleData,
        }
      };
      
      final response = await http.post(
        Uri.parse(ApiConfig.simulationUnified),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        final body = json.decode(utf8.decode(response.bodyBytes));
        throw Exception(body['detail'] ?? 'Lỗi khi mô phỏng: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
