import 'package:flutter/foundation.dart';
import '../models/health_profile.dart';
import '../services/storage_service.dart';

class HealthProfileProvider with ChangeNotifier {
  HealthProfile? _profile;
  final StorageService _storageService = StorageService();

  HealthProfile? get profile => _profile;

  bool get hasProfile => _profile != null;

  Future<void> loadProfile() async {
    _profile = await _storageService.getHealthProfile();
    notifyListeners();
  }

  Future<void> saveProfile(HealthProfile profile) async {
    _profile = profile;
    await _storageService.saveHealthProfile(profile);
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_profile == null) return;
    
    _profile = HealthProfile(
      id: _profile!.id,
      name: updates['name'] ?? _profile!.name,
      dateOfBirth: updates['dateOfBirth'] ?? _profile!.dateOfBirth,
      gender: updates['gender'] ?? _profile!.gender,
      height: updates['height'] ?? _profile!.height,
      weight: updates['weight'] ?? _profile!.weight,
      bloodType: updates['bloodType'] ?? _profile!.bloodType,
      medicalHistory: updates['medicalHistory'] ?? _profile!.medicalHistory,
      allergies: updates['allergies'] ?? _profile!.allergies,
      lastMenstrualPeriod: updates['lastMenstrualPeriod'] ?? _profile!.lastMenstrualPeriod,
      cycleLength: updates['cycleLength'] ?? _profile!.cycleLength,
      maleHealthData: updates['maleHealthData'] ?? _profile!.maleHealthData,
    );
    
    await _storageService.saveHealthProfile(_profile!);
    notifyListeners();
  }
}

