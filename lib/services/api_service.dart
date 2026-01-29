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
}

