class Tablet {
  final String id;
  final String guardianId;
  final String patientId;
  final String illnessType;
  final String tabletName;
  final String tabletFrequency;
  final String courseDuration;
  final Slot morningSlot;
  final Slot afternoonSlot;
  final Slot eveningSlot;

  Tablet({
    required this.id,
    required this.guardianId,
    required this.patientId,
    required this.illnessType,
    required this.tabletName,
    required this.tabletFrequency,
    required this.courseDuration,
    required this.morningSlot,
    required this.afternoonSlot,
    required this.eveningSlot,
  });

  factory Tablet.fromJson(Map<String, dynamic> json) {
    return Tablet(
      id: json['_id'] ?? '',
      guardianId: json['guardianId'] ?? '',
      patientId: json['patientId'] ?? '',
      illnessType: json['illnessType'] ?? '',
      tabletName: json['tabletName'] ?? '',
      tabletFrequency: json['tabletFrequencey'] ?? '', // Note: Typo in schema ("tabletFrequencey")
      courseDuration: json['CourseDuration'] ?? '', // Note: PascalCase in schema
      morningSlot: Slot.fromJson(json['MorningSlot'] ?? {}),
      afternoonSlot: Slot.fromJson(json['AfternoonSlot'] ?? {}),
      eveningSlot: Slot.fromJson(json['EveningSlot'] ?? {}),
    );
  }
}

class Slot {
  final bool slotSelected;
  final String slotStartTime;
  final String slotEndTime;
  final bool ScheduleRunning;

  Slot({
    required this.slotSelected,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.ScheduleRunning
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      slotSelected: json['SlotSelected'] ?? false,
      slotStartTime: json['SlotStartTime'] ?? '',
      slotEndTime: json['SlotEndTime'] ?? '',
      ScheduleRunning: json['ScheduleRunning'] ?? false
    );
  }
}
