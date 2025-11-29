import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_profile.dart';
import '../models/couple.dart';

class StorageService {
  static const String _profileKey = 'health_profile';
  static const String _coupleKey = 'couple_data';

  Future<void> saveHealthProfile(HealthProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<HealthProfile?> getHealthProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    if (profileJson == null) return null;
    return HealthProfile.fromJson(jsonDecode(profileJson));
  }

  Future<void> saveCouple(Couple couple) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_coupleKey, jsonEncode(couple.toJson()));
  }

  Future<Couple?> getCouple() async {
    final prefs = await SharedPreferences.getInstance();
    final coupleJson = prefs.getString(_coupleKey);
    if (coupleJson == null) return null;
    return Couple.fromJson(jsonDecode(coupleJson));
  }
}

