class Tabletsmodal {
  final String id;
  final String guardianId;
  final String patientId;
  final String TabletName;
  final String illnessType;
  final String tabletFrequencey;
  final String CourseDuration;
  final String SlotType;
  final String StartTime;
  final String EndTime;

  const Tabletsmodal({
    required this.id,
    required this.TabletName,
    required this.guardianId,
    required this.patientId,
    required this.illnessType,
    required this.tabletFrequencey,
    required this.CourseDuration,
    required this.SlotType,
    required this.StartTime,
    required this.EndTime,
  });

  factory Tabletsmodal.fromJson(Map<String, dynamic> json) {
    return Tabletsmodal(
      id: json["_id"],
      TabletName: json["tabletName"] ?? "",
      guardianId: json["guardianId"] ?? "",
      patientId: json["patientId"] ?? "",
      illnessType: json["illnessType"] ?? "",
      tabletFrequencey: json["tabletFrequencey"] ?? "",
      CourseDuration: json["CourseDuration"] ?? "",
      SlotType: json["SlotType"] ?? "",
      StartTime: json["SlotStartTime"] ?? "",
      EndTime: json["SlotEndTime"] ?? "",
    );
  }
}
