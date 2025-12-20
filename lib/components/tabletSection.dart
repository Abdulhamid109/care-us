import 'dart:convert';

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
  String? selectedValue = 'morning';
  String? SlotStartTimeSelected = '';
  String? SlotendTimeSelected = '';
  TimeOfDay? stTime; //this haven't used yet
  TimeOfDay? edTime; //this haven't used yet
  TextEditingController illnessController = TextEditingController();
  TextEditingController tabletName = TextEditingController();
  TextEditingController tabletfrequency = TextEditingController();
  TextEditingController courseDuration = TextEditingController();

  Future<void> addTabletDetails() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final data = JwtDecoder.decode(token!);
      final pid = await pref.getString("pid");
      //redefining the logic for slot st. time and slot end time
      print("s1 =>${data["uid"]}");
      print("s2 =>${pid}");
      print("s1 =>${data["uid"]}");
      print("s1 =>${data["uid"]}");
      print("s1 =>${data["uid"]}");
      print("s1 =>${data["uid"]}");
      print("s1 =>${data["uid"]}");
      print("s1 =>${data["uid"]}");
      print("s1 =>${data["uid"]}");
      final response = await http.post(
        Uri.parse("http://localhost:3000/api/addtablets"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guardianId': data["uid"],
          'patientId': pid,
          'illnessType': illnessController.text.toString(),
          'tabletName': tabletName.text.toString(),
          'tabletFrequencey': tabletfrequency.text.toString(),
          'CourseDuration': courseDuration.text.toString(),
          'SlotType': selectedValue!,
          'SlotStartTime': SlotStartTimeSelected!,
          'SlotEndTime': SlotendTimeSelected!,
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
          selectedValue = 'Morning';
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
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: DropdownButton(
                      barrierDismissible: true,
                      hint: Text("Select the Slot"),
                      value: selectedValue,
                      items: [
                        DropdownMenuItem(
                          value: "morning",
                          child: Text("Morning"),
                        ),
                        DropdownMenuItem(
                          value: "afternoon",
                          child: Text("Afternoon"),
                        ),
                        DropdownMenuItem(
                          value: "evening",
                          child: Text("Evening"),
                        ),
                      ],
                      onChanged: (String? value) {
                        print("Value => ${value}");
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(),
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
                                SlotStartTimeSelected = pickedTime.format(
                                  context,
                                );
                              });
                            }
                          },
                          child: Text(
                            "Start Time ${SlotStartTimeSelected ?? ""}",
                          ),
                        ),

                        // Note: For Course duration make sure you start from todays date till the end of the course duration
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(),
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
                                SlotendTimeSelected = pickedTime.format(
                                  context,
                                );
                              });
                            }
                          },
                          child: Text("End Time ${SlotendTimeSelected ?? ""}"),
                        ),
                      ],
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
                            addTabletDetails();
                          },
                          child: Text("Save Tablet info"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Add new Tablet"),
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
