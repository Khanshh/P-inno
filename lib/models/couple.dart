class Couple {
  String? id;
  String partner1Id;
  String partner2Id;
  DateTime? relationshipStartDate;
  List<Map<String, dynamic>> sharedNotes;
  List<Map<String, dynamic>> appointments;
  
  Couple({
    this.id,
    required this.partner1Id,
    required this.partner2Id,
    this.relationshipStartDate,
    this.sharedNotes = const [],
    this.appointments = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner1Id': partner1Id,
      'partner2Id': partner2Id,
      'relationshipStartDate': relationshipStartDate?.toIso8601String(),
      'sharedNotes': sharedNotes,
      'appointments': appointments,
    };
  }

  factory Couple.fromJson(Map<String, dynamic> json) {
    return Couple(
      id: json['id'],
      partner1Id: json['partner1Id'] ?? '',
      partner2Id: json['partner2Id'] ?? '',
      relationshipStartDate: json['relationshipStartDate'] != null
          ? DateTime.parse(json['relationshipStartDate'])
          : null,
      sharedNotes: List<Map<String, dynamic>>.from(json['sharedNotes'] ?? []),
      appointments: List<Map<String, dynamic>>.from(json['appointments'] ?? []),
    );
  }
}



