class UserProfileModel {
  final String username;
  final String fullName;
  final String patientCode;
  final String email;
  final String phone;
  final int age;
  final String address;

  UserProfileModel({
    required this.username,
    required this.fullName,
    required this.patientCode,
    required this.email,
    required this.phone,
    required this.age,
    required this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      username: json['username'],
      fullName: json['full_name'],
      patientCode: json['patient_code'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'full_name': fullName,
      'patient_code': patientCode,
      'email': email,
      'phone': phone,
      'age': age,
      'address': address,
    };
  }
}
