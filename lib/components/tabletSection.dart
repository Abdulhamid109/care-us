import 'dart:convert';

import 'package:careus/constants/domain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        Future.delayed(Duration(seconds: 3), () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fields get cleared after 3 sections")),
          );

          illnessController.clear();
          tabletName.clear();
          tabletfrequency.clear();
          courseDuration.clear();
          // selectedValue = 'Morning';
          SlotStartTimeSelected = '';
          SlotendTimeSelected = '';
        });
      } else {
        print(
          "Something went wrong statuscode ${response.statusCode} and message ${response.body}",
        );
      }
    } catch (e) {
      print("Failed to perform the functionality ${e}");
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
                          onPressed: () {
                            //start time and end time difference should not more than 4 hours
                            // do consider that after 12:00 am and before 6:00 am the user cannot add any tablet remider

                            if (tabletName.text.isEmpty ||
                                tabletfrequency.text.isEmpty ||
                                illnessController.text.isEmpty ||
                                courseDuration.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("Enter the respective data"),
                                ),
                              );
                            } else if (!morningSlotSelected! ||
                                !AfternoonSlotSelected! ||
                                !EveningSlotSelected!) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("Select the respective slots"),
                                ),
                              );
                            } else if (morningSlotSelected! &&
                                (MorningSlotStartTime!.isEmpty ||
                                    MorningSlotEndTime!.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Select the respective morning slot timing",
                                  ),
                                ),
                              );
                            } else if (AfternoonSlotSelected! &&
                                (AfternoonSlotStartTime!.isEmpty ||
                                    AfternoonSlotEndTime!.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Select the respective afternoon slot timing",
                                  ),
                                ),
                              );
                            } else if (EveningSlotSelected! &&
                                (EveningSlotStartTime!.isEmpty ||
                                    EveningSlotEndTime!.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Select the respective evening slot timing",
                                  ),
                                ),
                              );
                            } else if (MorningSlotStartTime!.contains("PM") &&
                                MorningSlotEndTime!.contains("PM")) {
                              print(
                                "kindly check the PM/AM for the selected time",
                              );
                            } else {}
                            addTabletDetails();
                          },
                          child: Text("Save"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("New Tablet"),
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
