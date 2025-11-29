class CycleTracking {
  final String id;
  final DateTime date;
  final String? periodStart; // 'light', 'medium', 'heavy'
  final String? periodEnd;
  final List<String> symptoms; // 'cramps', 'bloating', 'headache', etc.
  final String? mood; // 'happy', 'sad', 'anxious', 'energetic', etc.
  final String? energy; // 'low', 'medium', 'high'
  final String? sleep; // 'poor', 'fair', 'good'
  final String? notes;
  final String gender; // 'male' or 'female'
  final Map<String, dynamic>? maleHealthData; // For male tracking

  CycleTracking({
    required this.id,
    required this.date,
    this.periodStart,
    this.periodEnd,
    this.symptoms = const [],
    this.mood,
    this.energy,
    this.sleep,
    this.notes,
    required this.gender,
    this.maleHealthData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'periodStart': periodStart,
      'periodEnd': periodEnd,
      'symptoms': symptoms,
      'mood': mood,
      'energy': energy,
      'sleep': sleep,
      'notes': notes,
      'gender': gender,
      'maleHealthData': maleHealthData,
    };
  }

  factory CycleTracking.fromJson(Map<String, dynamic> json) {
    return CycleTracking(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      periodStart: json['periodStart'],
      periodEnd: json['periodEnd'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      mood: json['mood'],
      energy: json['energy'],
      sleep: json['sleep'],
      notes: json['notes'],
      gender: json['gender'] ?? 'female',
      maleHealthData: json['maleHealthData'],
    );
  }
}



