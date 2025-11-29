class HealthProfile {
  String? id;
  String name;
  DateTime? dateOfBirth;
  String gender; // 'male' or 'female'
  double? height;
  double? weight;
  String? bloodType;
  List<String> medicalHistory;
  List<String> allergies;
  String? lastMenstrualPeriod; // For female
  int? cycleLength; // For female
  Map<String, dynamic>? maleHealthData; // For male fertility data
  
  HealthProfile({
    this.id,
    required this.name,
    this.dateOfBirth,
    required this.gender,
    this.height,
    this.weight,
    this.bloodType,
    this.medicalHistory = const [],
    this.allergies = const [],
    this.lastMenstrualPeriod,
    this.cycleLength,
    this.maleHealthData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'lastMenstrualPeriod': lastMenstrualPeriod,
      'cycleLength': cycleLength,
      'maleHealthData': maleHealthData,
    };
  }

  factory HealthProfile.fromJson(Map<String, dynamic> json) {
    return HealthProfile(
      id: json['id'],
      name: json['name'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : null,
      gender: json['gender'] ?? 'female',
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      bloodType: json['bloodType'],
      medicalHistory: List<String>.from(json['medicalHistory'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      lastMenstrualPeriod: json['lastMenstrualPeriod'],
      cycleLength: json['cycleLength'],
      maleHealthData: json['maleHealthData'],
    );
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  double? get bmi {
    if (height == null || weight == null) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }
}

