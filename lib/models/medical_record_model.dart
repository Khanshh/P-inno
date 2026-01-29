class MedicalRecordModel {
  final String id;
  final String hospitalName;
  final String department;
  final String diagnosis;
  final String visitDate;
  final String? note;

  MedicalRecordModel({
    required this.id,
    required this.hospitalName,
    required this.department,
    required this.diagnosis,
    required this.visitDate,
    this.note,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'],
      hospitalName: json['hospital_name'],
      department: json['department'],
      diagnosis: json['diagnosis'],
      visitDate: json['visit_date'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospital_name': hospitalName,
      'department': department,
      'diagnosis': diagnosis,
      'visit_date': visitDate,
      'note': note,
    };
  }
}
