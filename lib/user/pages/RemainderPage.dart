import 'dart:convert';

import 'package:careus/constants/domain.dart';
import 'package:careus/models/patientModal.dart';
import 'package:careus/models/tabletsModal.dart';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Remainderpage extends StatefulWidget {
  const Remainderpage({super.key});

  @override
  State<Remainderpage> createState() => _RemainderpageState();
}

class _RemainderpageState extends State<Remainderpage> {
  //get the list of the patients along with the course duration timeing

  List<Patient> allPatients = [];
  List<Tablet> patientTablets = [];
  bool isLoading = true;

  Future<void> AllPatients() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final tokendata = await JwtDecoder.decode(token!);
      final uid = await tokendata["uid"];

      final response = await http.get(
        Uri.parse("$localhost/api/getallpatients/$uid"),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("List of patients whose guradian id is => $uid");
        print(response.body);
        List<dynamic> patientsList = jsonData["Patients"];

        print("Result => ${jsonData["Patients"]}");

        setState(() {
          allPatients = patientsList
              .map((patient) => Patient.fromJson(patient))
              .toList();
          isLoading = false;
        });

        //here we will be calling the tablets details page
      } else {
        print(
          "Error occured at ${response.statusCode} of body => ${response.body}",
        );
      }
    } catch (e) {
      print("Failed to perform the funtionality => $e");
    }
  }

  //tablets detail of each patient

  Future<List<Tablet>> patientTabletDetails(String pid) async {
    try {
      if (pid.isEmpty) {
        print("The Patient ID is not provided!");
        return [];
      }
      final response = await http.get(
        Uri.parse("$localhost/api/getPatientTablet/$pid"),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> tabletList = jsonData["patients"];
        return tabletList.map((tablet) => Tablet.fromJson(tablet)).toList();
      } else {
        print("Error occurred at ${response.statusCode}: ${response.body}");
        throw Exception("Failed to load tablets: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to perform the functionality: $e");
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    AllPatients();
  }

  //Morning Schedule manipulations
  Future<bool> StopMorningSchedule(String tid) async {
    try {
      final response = await http.put(
        Uri.parse("$localhost/api/morningjobstop/$tid"),
      );
      if (response.statusCode == 200) {
        print("Response body => ${response.body}");
        return true;
      } else {
        print(
          "Error occured at ${response.statusCode} with body as ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Failed to perform the functionaliy => $e");
      throw e;
    }
  }

  Future<bool> startMorningSchedular(String id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final tokendata = await JwtDecoder.decode(token!);
      final uid = tokendata["uid"];
      final response = await http.put(
        Uri.parse("$localhost/api/morningjobstart/$id/$uid"),
      );
      if (response.statusCode == 200) {
        print("Response body => ${response.body}");
        return true;
      } else {
        print(
          "Error occured : Status-Code ${response.statusCode} with body => ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Failed to perform the functionality => $e");
      throw e;
    }
  }

  //Afternoon Schedule manipulations
  Future<bool> stopAfternoonSchedule(String tid) async {
    try {
      final response = await http.put(
        Uri.parse("$localhost/api/afternoonjobstop/$tid"),
      );
      if (response.statusCode == 200) {
        print("Response body => ${response.body}");
        return true;
      } else {
        print(
          "Error occured at ${response.statusCode} with body as ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Failed to perform the functionaliy => $e");
      throw e;
    }
  }

  Future<bool> startAfternoonSchedular(String id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final tokendata = await JwtDecoder.decode(token!);
      final uid = tokendata["uid"];
      final response = await http.put(
        Uri.parse("$localhost/api/afternoonjobstop/$id/$uid"),
      );
      if (response.statusCode == 200) {
        print("Response body => ${response.body}");
        return true;
      } else {
        print(
          "Error occured : Status-Code ${response.statusCode} with body => ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Failed to perform the functionality => $e");
      throw e;
    }
  }

  //Evening Schedule manipulations
  Future<bool> stopEveningSchedule(String tid) async {
    try {
      final response = await http.put(
        Uri.parse("$localhost/api/eveningjobstop/$tid"),
      );
      if (response.statusCode == 200) {
        print("Response body => ${response.body}");
        return true;
      } else {
        print(
          "Error occured at ${response.statusCode} with body as ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Failed to perform the functionaliy => $e");
      throw e;
    }
  }

  Future<bool> startEveningSchedular(String id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final tokendata = await JwtDecoder.decode(token!);
      final uid = tokendata["uid"];
      final response = await http.put(
        Uri.parse("$localhost/api/eveningjobstop/$id/$uid"),
      );
      if (response.statusCode == 200) {
        print("Response body => ${response.body}");
        return true;
      } else {
        print(
          "Error occured : Status-Code ${response.statusCode} with body => ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Failed to perform the functionality => $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    double width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "Remainder Section"),
      ),
      drawer: Customdrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : allPatients.isEmpty
          ? Center(child: Text("No Data Available"))
          : ListView.builder(
              itemCount: allPatients.length,
              itemBuilder: (context, index) {
                final patient = allPatients[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "${patient.patientName}",
                        style: TextStyle(fontSize: 23),
                      ),
                      subtitle: Column(
                        children: [
                          //use of future builder over here....
                          FutureBuilder<List<Tablet>>(
                            future: patientTabletDetails(patient.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    "Error: ${snapshot.error}",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, i) {
                                    final tablet = snapshot.data![i];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Tablet Name : ${tablet.tabletName}",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    scrollable: true,
                                                    title: Text(
                                                      tablet.tabletName,
                                                    ),
                                                    content: SizedBox(
                                                      height: height * 0.7,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Tablet Frequency : ${tablet.tabletFrequency}",
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          Text(
                                                            "Duration : ${tablet.courseDuration}",
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          Text(
                                                            "Slots Running",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          tablet
                                                                  .morningSlot
                                                                  .slotSelected
                                                              ? tablet
                                                                        .morningSlot
                                                                        .ScheduleRunning
                                                                    ? Container(
                                                                        decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(),
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            "Morning Slot : ${tablet.morningSlot.slotStartTime}-${tablet.morningSlot.slotEndTime}",
                                                                          ),
                                                                          subtitle: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Status : Running",
                                                                                style: TextStyle(
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.red,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  bool status = await StopMorningSchedule(
                                                                                    tablet.id,
                                                                                  );
                                                                                  //making the call to the backend and accordingly updating the state
                                                                                  setState(
                                                                                    () {
                                                                                      if (status &&
                                                                                          mounted) {
                                                                                        tablet.morningSlot.ScheduleRunning = false;
                                                                                        Navigator.pop(
                                                                                          context,
                                                                                        );
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(
                                                                                          context,
                                                                                        ).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              "Failed to stop schedule",
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Text(
                                                                                  "Stop",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(),
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            "Morning Slot : ${tablet.morningSlot.slotStartTime}-${tablet.morningSlot.slotEndTime}",
                                                                          ),
                                                                          subtitle: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Status : Stopped",
                                                                                style: TextStyle(
                                                                                  color: Colors.red,
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.green,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  bool status = await startMorningSchedular(
                                                                                    tablet.id,
                                                                                  );
                                                                                  setState(
                                                                                    () {
                                                                                      if (status &&
                                                                                          mounted) {
                                                                                        tablet.morningSlot.ScheduleRunning = true;
                                                                                        Navigator.pop(
                                                                                          context,
                                                                                        );
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(
                                                                                          context,
                                                                                        ).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              "Failed to start schedule",
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Text(
                                                                                  "Start",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                              : Text(
                                                                  "morning Slot not available",
                                                                ),

                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          tablet
                                                                  .afternoonSlot
                                                                  .slotSelected
                                                              ? tablet
                                                                        .afternoonSlot
                                                                        .ScheduleRunning
                                                                    ? Container(
                                                                        decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(),
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            "Afternoon Slot : ${tablet.afternoonSlot.slotStartTime}-${tablet.afternoonSlot.slotEndTime}",
                                                                          ),
                                                                          subtitle: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Status : Running",
                                                                                style: TextStyle(
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.red,
                                                                                ),
                                                                                onPressed: () async{
                                                                                  //making the call to the backend and accordingly updating the state
                                                                                  bool status = await stopAfternoonSchedule(
                                                                                    tablet.id,
                                                                                  );
                                                                                  //making the call to the backend and accordingly updating the state
                                                                                  setState(
                                                                                    () {
                                                                                      if (status &&
                                                                                          mounted) {
                                                                                        tablet.morningSlot.ScheduleRunning = false;
                                                                                        Navigator.pop(
                                                                                          context,
                                                                                        );
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(
                                                                                          context,
                                                                                        ).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              "Failed to stop schedule",
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Text(
                                                                                  "Stop",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(),
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            "Afternoon Slot : ${tablet.afternoonSlot.slotStartTime}-${tablet.afternoonSlot.slotEndTime}",
                                                                          ),
                                                                          subtitle: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Status : Stopped",
                                                                                style: TextStyle(
                                                                                  color: Colors.red,
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.green,
                                                                                ),
                                                                                onPressed: () async{
                                                                                  bool status = await startAfternoonSchedular(
                                                                                    tablet.id,
                                                                                  );
                                                                                  //making the call to the backend and accordingly updating the state
                                                                                  setState(
                                                                                    () {
                                                                                      if (status &&
                                                                                          mounted) {
                                                                                        tablet.morningSlot.ScheduleRunning = false;
                                                                                        Navigator.pop(
                                                                                          context,
                                                                                        );
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(
                                                                                          context,
                                                                                        ).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              "Failed to start schedule",
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Text(
                                                                                  "Start",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                              : Text(
                                                                  "Afternoon Slot not available",
                                                                ),

                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          tablet
                                                                  .eveningSlot
                                                                  .slotSelected
                                                              ? tablet
                                                                        .eveningSlot
                                                                        .ScheduleRunning
                                                                    ? Container(
                                                                        decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(),
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            "Evening Slot : ${tablet.eveningSlot.slotStartTime}-${tablet.eveningSlot.slotEndTime}",
                                                                          ),
                                                                          subtitle: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Status : Running",
                                                                                style: TextStyle(
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.red,
                                                                                ),
                                                                                onPressed: ()async {
                                                                                  //making the call to the backend and accordingly updating the state
                                                                                  bool status = await stopEveningSchedule(
                                                                                    tablet.id,
                                                                                  );
                                                                                  //making the call to the backend and accordingly updating the state
                                                                                  setState(
                                                                                    () {
                                                                                      if (status &&
                                                                                          mounted) {
                                                                                        tablet.morningSlot.ScheduleRunning = false;
                                                                                        Navigator.pop(
                                                                                          context,
                                                                                        );
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(
                                                                                          context,
                                                                                        ).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              "Failed to stop schedule",
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Text(
                                                                                  "Stop",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(),
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            "Evening Slot : ${tablet.eveningSlot.slotStartTime}-${tablet.eveningSlot.slotEndTime}",
                                                                          ),
                                                                          subtitle: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Status : Stopped",
                                                                                style: TextStyle(
                                                                                  color: Colors.red,
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.green,
                                                                                ),
                                                                                onPressed: () async{
                                                                                  bool status = await startEveningSchedular(
                                                                                    tablet.id,
                                                                                  );
                                                                                  //making the call to the backend and accordingly updating the state
                                                                                  setState(
                                                                                    () {
                                                                                      if (status &&
                                                                                          mounted) {
                                                                                        tablet.morningSlot.ScheduleRunning = false;
                                                                                        Navigator.pop(
                                                                                          context,
                                                                                        );
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(
                                                                                          context,
                                                                                        ).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text(
                                                                                              "Failed to start schedule",
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Text(
                                                                                  "Start",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                              : Text(
                                                                  "Evening Slot not available",
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              "Open",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              return Text("No tablets available");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
