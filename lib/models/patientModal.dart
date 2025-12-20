class Patient {
  final String id;
  final String guardianId;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String phoneNumber;
  final String address;

  Patient({
    required this.id,
    required this.guardianId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.phoneNumber,
    required this.address,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] ?? '',
      guardianId: json['guardianId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAge: json['patientAge'] ?? '',
      patientGender: json['patientGender'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['Address'] ?? '',
    );
  }
}