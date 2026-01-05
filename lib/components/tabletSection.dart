import 'dart:convert';

import 'package:careus/constants/domain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabletsection extends StatefulWidget {
  const Tabletsection({super.key});

  @override
  State<Tabletsection> createState() => _TabletsectionState();
}

class _TabletsectionState extends State<Tabletsection> {
  String? SlotStartTimeSelected = '';
  String? SlotendTimeSelected = '';
  TimeOfDay? stTime; //this haven't used yet
  TimeOfDay? edTime; //this haven't used yet
  TextEditingController illnessController = TextEditingController();
  TextEditingController tabletName = TextEditingController();
  TextEditingController tabletfrequency = TextEditingController();
  TextEditingController courseDuration = TextEditingController();
  //for morning slot
  String? MorningSlot = 'Morning';
  bool? morningSlotSelected = false;
  String? MorningSlotStartTime = '';
  String? MorningSlotEndTime = '';
  //for afternoon slot
  String? AfternoonSlot = 'Afternoon';
  bool? AfternoonSlotSelected = false;
  String? AfternoonSlotStartTime;
  String? AfternoonSlotEndTime;
  //for evening slot
  String? EveningSlot = 'Evening';
  bool? EveningSlotSelected = false;
  String? EveningSlotStartTime;
  String? EveningSlotEndTime;
  

  Future<void> addTabletDetails() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final data = JwtDecoder.decode(token!);
      final pid = await pref.getString("pid");
      //redefining the logic for slot st. time and slot end time
      print("Request Body:"); // Debug: Log the request body
      print({
        'guardianId': data["uid"],
        'patientId': pid,
        'illnessType': illnessController.text.toString(),
        'tabletName': tabletName.text.toString(),
        'tabletFrequencey': tabletfrequency.text.toString(),
        'CourseDuration': courseDuration.text.toString(),
        'MorningSlot': {
          'SlotSelected': morningSlotSelected,
          'SlotStartTime': MorningSlotStartTime,
          'SlotEndTime': MorningSlotEndTime,
        },
        'AfternoonSlot': {
          'SlotSelected': AfternoonSlotSelected,
          'SlotStartTime': AfternoonSlotStartTime,
          'SlotEndTime': AfternoonSlotEndTime,
        },
        'EveningSlot': {
          'SlotSelected': EveningSlotSelected,
          'SlotStartTime': EveningSlotStartTime,
          'SlotEndTime': EveningSlotEndTime,
        },
      });
      final response = await http.post(
        Uri.parse("$localhost/api/addtablets"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guardianId': data["uid"],
          'patientId': pid,
          'illnessType': illnessController.text.toString(),
          'tabletName': tabletName.text.toString(),
          'tabletFrequencey': tabletfrequency.text.toString(),
          'CourseDuration': courseDuration.text.toString(),
          // 'SlotType': selectedValue!,
          'MorningSlot': {
            'SlotSelected': morningSlotSelected,
            'SlotStartTime': MorningSlotStartTime,
            'SlotEndTime': MorningSlotEndTime,
          },
          'AfternoonSlot': {
            'SlotSelected': AfternoonSlotSelected,
            'SlotStartTime': AfternoonSlotStartTime,
            'SlotEndTime': AfternoonSlotEndTime,
          },
          'EveningSlot': {
            'SlotSelected': EveningSlotSelected,
            'SlotStartTime': EveningSlotStartTime,
            'SlotEndTime': EveningSlotEndTime,
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Successfully added the tablets ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fields get cleared after 3 sections")),
        );
        final jsondata = await jsonDecode(response.body);
        final tabletdata = jsondata["tablets"];
        final tabletid = tabletdata["_id"];
        // Future.delayed(Duration(seconds: 3), () {
        //   illnessController.clear();
        //   tabletName.clear();
        //   tabletfrequency.clear();
        //   courseDuration.clear();
        //   // selectedValue = 'Morning';
        //   morningSlotSelected = false;
        //   AfternoonSlotSelected = false;
        //   EveningSlotSelected = false;

        //   MorningSlotStartTime = '';
        //   MorningSlotEndTime = '';

        //   AfternoonSlotStartTime = '';
        //   AfternoonSlotEndTime = '';

        //   EveningSlotStartTime = '';
        //   EveningSlotEndTime = '';
        // });
        print("8888888888888888888888888888888");
        print("Tablets id "+tabletid);
        print("77777777777777777777777777777");
        await callInstantiate(tabletid);
      
      } else {
        print(
          "Something went wrong statuscode ${response.statusCode} and message ${response.body}",
        );
      }
    } catch (e) {
      print("Failed to perform the functionality ${e}");
    }
  }

  Future callInstantiate(String tabletid) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final tokenData = await JwtDecoder.decode(token!);
      final uid = await tokenData["uid"];
      final pid = await pref.getString("pid");
      final response = await http.post(
        Uri.parse("$localhost/api/ivr/makecall"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guardianId': uid,
          'phoneNumber': "+919860573041",
          'pid':pid,
          'tabletid': tabletid,
          'MorningSlot': {
            'SlotSelected': morningSlotSelected,
            'SlotStartTime': MorningSlotStartTime,
            'SlotEndTime': MorningSlotEndTime,
          },
          'AfternoonSlot': {
            'SlotSelected': AfternoonSlotSelected,
            'SlotStartTime': AfternoonSlotStartTime,
            'SlotEndTime': AfternoonSlotEndTime,
          },
          'EveningSlot': {
            'SlotSelected': EveningSlotSelected,
            'SlotStartTime': EveningSlotStartTime,
            'SlotEndTime': EveningSlotEndTime,
          },
        }),
      );

      if (response.statusCode == 200) {
        print("Response => ${response.body}");
      } else {
        print(
          "Error at response code ${response.statusCode} with response body ${response.body}",
        );
      }
    } catch (e) {
      print("Failed to perform the functionality => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Tablets",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: illnessController,
                decoration: InputDecoration(
                  labelText: "illness type",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tabletName,
                decoration: InputDecoration(
                  labelText: "Tablet Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tabletfrequency,
                decoration: InputDecoration(
                  labelText: "Tablet Frequency",
                  hintText: "At what freq. do you take med in a day",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: courseDuration,
                decoration: InputDecoration(
                  labelText: "Course Duration",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.01),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Tablet Eating Reminder Slot",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Morning Slot",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        Checkbox(
                          value: morningSlotSelected,
                          onChanged: (bool? v) {
                            setState(() {
                              morningSlotSelected = v;
                            });
                          },
                        ),
                      ],
                    ),
                    subtitle: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                print(
                                  "Selected time: ${pickedTime.format(context)}",
                                );
                                setState(() {
                                  MorningSlotStartTime = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                            child: Text(
                              "Start Time ${MorningSlotStartTime ?? ""}",
                            ),
                          ),
                          // Note: For Course duration make sure you start from todays date till the end of the course duration
                          SizedBox(width: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: TimeOfDay.now().hour + 4,
                                  minute: 0,
                                ),
                              );
                              if (pickedTime != null) {
                                print(
                                  "Selected time: ${pickedTime.format(context)}",
                                );
                                setState(() {
                                  MorningSlotEndTime = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                            child: Text("End Time ${MorningSlotEndTime ?? ""}"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Afternoon Slot",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        Checkbox(
                          value: AfternoonSlotSelected,
                          onChanged: (bool? v) {
                            setState(() {
                              AfternoonSlotSelected = v;
                            });
                            print(v);
                          },
                        ),
                      ],
                    ),
                    subtitle: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                print(
                                  "Selected time: ${pickedTime.format(context)}",
                                );
                                setState(() {
                                  AfternoonSlotStartTime = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                            child: Text(
                              "Start Time ${AfternoonSlotStartTime ?? ""}",
                            ),
                          ),
                          // Note: For Course duration make sure you start from todays date till the end of the course duration
                          SizedBox(width: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: TimeOfDay.now().hour + 4,
                                  minute: 0,
                                ),
                              );
                              if (pickedTime != null) {
                                print(
                                  "Selected time: ${pickedTime.format(context)}",
                                );
                                setState(() {
                                  AfternoonSlotEndTime = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                            child: Text(
                              "End Time ${AfternoonSlotEndTime ?? ""}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Evening Slot",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        Checkbox(
                          value: EveningSlotSelected,
                          onChanged: (bool? v) {
                            setState(() {
                              EveningSlotSelected = v;
                            });
                            print(v);
                          },
                        ),
                      ],
                    ),
                    subtitle: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                print(
                                  "Selected time: ${pickedTime.format(context)}",
                                );
                                setState(() {
                                  EveningSlotStartTime = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                            child: Text(
                              "Start Time ${EveningSlotStartTime ?? ""}",
                            ),
                          ),
                          // Note: For Course duration make sure you start from todays date till the end of the course duration
                          SizedBox(width: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(10),
                                ),
                              ),
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                  hour: TimeOfDay.now().hour + 4,
                                  minute: 0,
                                ),
                              );
                              if (pickedTime != null) {
                                print(
                                  "Selected time: ${pickedTime.format(context)}",
                                );
                                setState(() {
                                  EveningSlotEndTime = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                            child: Text("End Time ${EveningSlotEndTime ?? ""}"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async{
                            // Check if required fields are empty
                            if (tabletName.text.isEmpty ||
                                tabletfrequency.text.isEmpty ||
                                illnessController.text.isEmpty ||
                                courseDuration.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Please fill in all required fields",
                                  ),
                                ),
                              );
                              return;
                            }

                            // Check if at least one slot is selected
                            if (!morningSlotSelected! &&
                                !AfternoonSlotSelected! &&
                                !EveningSlotSelected!) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Please select at least one slot",
                                  ),
                                ),
                              );
                              return;
                            }

                            // Helper function to parse time string to DateTime
                            DateTime? parseTime(String time) {
                              try {
                                return DateFormat("h:mm a").parse(time);
                              } catch (e) {
                                return null;
                              }
                            }

                            // Helper function to check if time is within a specific range
                            bool isTimeInRange(
                              DateTime time,
                              DateTime start,
                              DateTime end,
                            ) {
                              return time.isAfter(start) && time.isBefore(end);
                            }

                            // Helper function to calculate time difference in hours
                            double calculateTimeDifference(
                              String startTime,
                              String endTime,
                            ) {
                              try {
                                final format = DateFormat("h:mm a");
                                final start = format.parse(startTime);
                                final end = format.parse(endTime);
                                return end.difference(start).inHours.toDouble();
                              } catch (e) {
                                return 5; // Return a value > 4 to trigger the error
                              }
                            }

                            // Define time ranges for slots
                            final morningStart = DateFormat(
                              "h:mm a",
                            ).parse("6:00 AM");
                            final morningEnd = DateFormat(
                              "h:mm a",
                            ).parse("11:59 AM");
                            final afternoonStart = DateFormat(
                              "h:mm a",
                            ).parse("12:00 PM");
                            final afternoonEnd = DateFormat(
                              "h:mm a",
                            ).parse("5:59 PM");
                            final eveningStart = DateFormat(
                              "h:mm a",
                            ).parse("6:00 PM");
                            final eveningEnd = DateFormat(
                              "h:mm a",
                            ).parse("11:59 PM");
                            final restrictedStart = DateFormat(
                              "h:mm a",
                            ).parse("12:00 AM");
                            final restrictedEnd = DateFormat(
                              "h:mm a",
                            ).parse("6:00 AM");

                            // Check morning slot
                            if (morningSlotSelected!) {
                              if (MorningSlotStartTime!.isEmpty ||
                                  MorningSlotEndTime!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Please enter start and end times for the morning slot",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final startTime = parseTime(
                                MorningSlotStartTime!,
                              );
                              final endTime = parseTime(MorningSlotEndTime!);

                              if (startTime == null || endTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Invalid time format for morning slot",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if time is in restricted period (12 AM - 6 AM)
                              if (isTimeInRange(
                                    startTime,
                                    restrictedStart,
                                    restrictedEnd,
                                  ) ||
                                  isTimeInRange(
                                    endTime,
                                    restrictedStart,
                                    restrictedEnd,
                                  )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Reminders cannot be set between 12:00 AM and 6:00 AM",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if time is within morning slot range (6 AM - 11:59 AM)
                              if (!isTimeInRange(
                                    startTime,
                                    morningStart,
                                    morningEnd,
                                  ) ||
                                  !isTimeInRange(
                                    endTime,
                                    morningStart,
                                    morningEnd,
                                  )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Morning slot must be between 6:00 AM and 11:59 AM",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if duration exceeds 4 hours
                              if (calculateTimeDifference(
                                    MorningSlotStartTime!,
                                    MorningSlotEndTime!,
                                  ) >
                                  4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Morning slot duration cannot exceed 4 hours",
                                    ),
                                  ),
                                );
                                return;
                              }
                            }

                            // Check afternoon slot
                            if (AfternoonSlotSelected!) {
                              if (AfternoonSlotStartTime!.isEmpty ||
                                  AfternoonSlotEndTime!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Please enter start and end times for the afternoon slot",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final startTime = parseTime(
                                AfternoonSlotStartTime!,
                              );
                              final endTime = parseTime(AfternoonSlotEndTime!);

                              if (startTime == null || endTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Invalid time format for afternoon slot",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if time is in restricted period (12 AM - 6 AM)
                              if (isTimeInRange(
                                    startTime,
                                    restrictedStart,
                                    restrictedEnd,
                                  ) ||
                                  isTimeInRange(
                                    endTime,
                                    restrictedStart,
                                    restrictedEnd,
                                  )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Reminders cannot be set between 12:00 AM and 6:00 AM",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if time is within afternoon slot range (12 PM - 5:59 PM)
                              if (!isTimeInRange(
                                    startTime,
                                    afternoonStart,
                                    afternoonEnd,
                                  ) ||
                                  !isTimeInRange(
                                    endTime,
                                    afternoonStart,
                                    afternoonEnd,
                                  )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Afternoon slot must be between 12:00 PM and 5:59 PM",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if duration exceeds 4 hours
                              if (calculateTimeDifference(
                                    AfternoonSlotStartTime!,
                                    AfternoonSlotEndTime!,
                                  ) >
                                  4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Afternoon slot duration cannot exceed 4 hours",
                                    ),
                                  ),
                                );
                                return;
                              }
                            }

                            // Check evening slot
                            if (EveningSlotSelected!) {
                              if (EveningSlotStartTime!.isEmpty ||
                                  EveningSlotEndTime!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Please enter start and end times for the evening slot",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final startTime = parseTime(
                                EveningSlotStartTime!,
                              );
                              final endTime = parseTime(EveningSlotEndTime!);

                              if (startTime == null || endTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Invalid time format for evening slot",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if time is in restricted period (12 AM - 6 AM)
                              if (isTimeInRange(
                                    startTime,
                                    restrictedStart,
                                    restrictedEnd,
                                  ) ||
                                  isTimeInRange(
                                    endTime,
                                    restrictedStart,
                                    restrictedEnd,
                                  )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Reminders cannot be set between 12:00 AM and 6:00 AM",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if time is within evening slot range (6 PM - 11:59 PM)
                              if (!isTimeInRange(
                                    startTime,
                                    eveningStart,
                                    eveningEnd,
                                  ) ||
                                  !isTimeInRange(
                                    endTime,
                                    eveningStart,
                                    eveningEnd,
                                  )) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Evening slot must be between 6:00 PM and 11:59 PM",
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Check if duration exceeds 4 hours
                              if (calculateTimeDifference(
                                    EveningSlotStartTime!,
                                    EveningSlotEndTime!,
                                  ) >
                                  4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Evening slot duration cannot exceed 4 hours",
                                    ),
                                  ),
                                );
                                return;
                              }
                            }
                            final tabfreq = int.tryParse(
                              tabletfrequency.text.toString(),
                            );
                            if (tabfreq! > 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "tablet frequency cannot be more than 3",
                                  ),
                                ),
                              );
                              return;
                            }
                            int slotcount = 0;
                            if (morningSlotSelected!) {
                              setState(() {
                                slotcount++;
                              });
                            }
                            ;
                            if (AfternoonSlotSelected!) {
                              setState(() {
                                slotcount++;
                              });
                            }
                            ;
                            if (EveningSlotSelected!) {
                              setState(() {
                                slotcount++;
                              });
                            }
                            ;

                            if (slotcount != tabfreq) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "tablet frequency and slots selected are not same",
                                  ),
                                ),
                              );
                              return;
                            }

                            // If all validations pass, add the tablet details
                            await addTabletDetails();
                            
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
