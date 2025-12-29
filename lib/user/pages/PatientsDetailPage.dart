// TODO : UI update need to be done as per the new Schema configuration along with this function...

import 'dart:convert';
import 'package:careus/constants/domain.dart';
import 'package:careus/models/tabletsModal.dart';
import 'package:careus/user/pages/IVR.dart';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Patientsdetailpage extends StatefulWidget {
  final String pid;
  const Patientsdetailpage({required this.pid, super.key});

  @override
  State<Patientsdetailpage> createState() => _PatientsdetailpageState();
}

class _PatientsdetailpageState extends State<Patientsdetailpage> {
  // Controllers for editing tablet data
  TextEditingController illnessTypeController = TextEditingController();
  TextEditingController tabletNameController = TextEditingController();
  TextEditingController tabletFrequencyController = TextEditingController();
  TextEditingController courseDurationController = TextEditingController();
  // TextEditingController mSlotController = TextEditingController();

  TextEditingController MstartTimeController = TextEditingController();
  TextEditingController MendTimeController = TextEditingController();
  TextEditingController AstartTimeController = TextEditingController();
  TextEditingController AendTimeController = TextEditingController();
  TextEditingController EstartTimeController = TextEditingController();
  TextEditingController EendTimeController = TextEditingController();
  bool? mSlotSelected;
  bool? aSlotSelected;
  bool? eSlotSelected;

  Future<Map<String, dynamic>>? tabletData;
  List<Tablet> mypatients = [];

  Future<Map<String, dynamic>> getPersonalData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:3000/api/getPatientPersonalData/${widget.pid}",
        ),
      );
      if (response.statusCode == 200) {
        print("Successfully fetched the data from the backend");
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse["patient"]);
        return jsonResponse;
      } else {
        print("Error at ${response.statusCode} at response ${response.body}");
        throw Exception("Failed to fetch profile data");
      }
    } catch (e) {
      print("Failed to perform the functionality $e");
      throw e;
    }
  }

  Future<void> getMedicalTablets() async {
    try {
      final response = await http.get(
        Uri.parse("$localhost/api/getPatientTablet/${widget.pid}"),
      );
      if (response.statusCode == 200) {
        // print("Data: ${response.body}");
        final jsonData = jsonDecode(response.body);
        List<dynamic> tablets = jsonData["patients"];
        print("Data => $tablets");
        setState(() {
          mypatients = tablets
              .map((tablet) => Tablet.fromJson(tablet))
              .toList();
        });
        print("-------------------");
        print(mypatients);
        print("-------------------");
      } else {
        print(
          "Something went wrong at ${response.statusCode} with response ${response.body}",
        );
      }
    } catch (e) {
      print("Failed to perform the functionality $e");
    }
  }

  Future<void> updateMedicalHistory(
    String illness,
    String tabletName,
    String freq,
    String duration,
    String MstTime,
    String MedTime,
    String AstTime,
    String AedTime,
    String EstTime,
    String EedTime,
  ) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString("token");
      final decodedData = JwtDecoder.decode(token!);
      final uid = decodedData["uid"];

      final response = await http.put(
        Uri.parse("$localhost/api/updateMedicalhistory/${widget.pid}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "guardianId": uid,
          "patientId": widget.pid,
          "illnessType": illnessTypeController.text.isEmpty
              ? illness
              : illnessTypeController.text,
          "tabletName": tabletNameController.text.isEmpty
              ? tabletName
              : tabletNameController.text,
          "tabletFrequency": tabletFrequencyController.text.isEmpty
              ? freq
              : tabletFrequencyController.text,
          "CourseDuration": courseDurationController.text.isEmpty
              ? duration
              : courseDurationController.text,
          "MorningSlot": {
            "SlotSelected": mSlotSelected,
            "SlotStartTime": mSlotSelected!
                ? (MstartTimeController.text.isEmpty
                      ? MstTime
                      : MstartTimeController.text)
                : MstTime,
            "SlotEndTime": mSlotSelected!
                ? (MendTimeController.text.isEmpty
                      ? MedTime
                      : MendTimeController.text)
                : MedTime,
          },
          "AfternoonSlot": {
            "SlotSelected": aSlotSelected,
            "SlotStartTime": aSlotSelected!
                ? (AstartTimeController.text.isEmpty
                      ? AstTime
                      : AstartTimeController.text)
                : AstTime,
            "SlotEndTime": aSlotSelected!
                ? (AendTimeController.text.isEmpty
                      ? AedTime
                      : AendTimeController.text)
                : AedTime,
          },
          "EveningSlot": {
            "SlotSelected": eSlotSelected,
            "SlotStartTime": eSlotSelected!
                ? (EstartTimeController.text.isEmpty
                      ? EstTime
                      : EstartTimeController.text)
                : EstTime,
            "SlotEndTime": eSlotSelected!
                ? (EendTimeController.text.isEmpty
                      ? EedTime
                      : EendTimeController.text)
                : EedTime,
          },
        }),
      );
      if (response.statusCode == 200) {
        print(
          "Successfully updated the data with the response as ${response.body}",
        );
        Navigator.pop(context);
        setState(() {
          getMedicalTablets();
        });
      } else {
        print("Status-code ${response.statusCode} => ${response.body}");
      }
    } catch (e) {
      print("Failed to perform the functionality $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getMedicalTablets();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: const Customappbar(ScreenTitle: "Patient Details"),
      ),
      drawer: const Customdrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Data Card
              FutureBuilder(
                future: getPersonalData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Personal Data",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            // Name
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Name:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!["patient"]["patientName"] ??
                                          "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Age
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Age:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!["patient"]["patientAge"] ??
                                          "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Phone
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Phone:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "+91 ${snapshot.data!["patient"]["phoneNumber"] ?? ""}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Address
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Address:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!["patient"]["Address"] ??
                                          "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Gender
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Gender:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!["patient"]["patientGender"] ??
                                          "Male",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                  return const Text("");
                },
              ),
              SizedBox(height: height * 0.03),
              // Medical History Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Medical History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      // Tablet List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mypatients.length,
                        itemBuilder: (context, index) {
                          final tablet = mypatients[index];
                          print(tablet.morningSlot.slotSelected);
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Illness Type
                                  Text(
                                    "Illness Type:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tablet.illnessType,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  // Tablet Information
                                  Text(
                                    "Tablet Information:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Tablet Name
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "Name:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            tablet.tabletName,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Frequency
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "Frequency:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            tablet.tabletFrequency,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Duration
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "Duration:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            tablet.courseDuration,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  // Slot Information
                                  Text(
                                    "Slot Information:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Morning Slot
                                  if (tablet.morningSlot.slotSelected)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: .spaceBetween,
                                          children: [
                                            Text(
                                              "Morning Slot",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[800],
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                const Text(
                                                  "Start: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  tablet
                                                      .morningSlot
                                                      .slotStartTime,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                const Text(
                                                  "End: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  tablet
                                                      .morningSlot
                                                      .slotEndTime,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Afternoon Slot
                                  if (tablet.afternoonSlot.slotSelected)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: .spaceBetween,
                                          children: [
                                            Text(
                                              "Afternoon Slot:",
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[800],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Start: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  tablet
                                                      .afternoonSlot
                                                      .slotStartTime,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                const Text(
                                                  "End: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  tablet
                                                      .afternoonSlot
                                                      .slotEndTime,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Evening Slot
                                  if (tablet.eveningSlot.slotSelected)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: .spaceBetween,
                                          children: [
                                            Text(
                                              "Evening Slot:",
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[800],
                                              ),
                                            ),

                                            Row(
                                              children: [
                                                const Text(
                                                  "Start: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  tablet
                                                      .eveningSlot
                                                      .slotStartTime,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                const Text(
                                                  "End: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  tablet
                                                      .eveningSlot
                                                      .slotEndTime,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Edit and IVR Buttons
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () {
                                            illnessTypeController.text =
                                                tablet.illnessType;
                                            tabletNameController.text =
                                                tablet.tabletName;
                                            tabletFrequencyController.text =
                                                tablet.tabletFrequency;
                                            courseDurationController.text =
                                                tablet.courseDuration;
                                            MstartTimeController.text = tablet
                                                .morningSlot
                                                .slotStartTime;
                                            MendTimeController.text =
                                                tablet.morningSlot.slotEndTime;
                                            AstartTimeController.text = tablet
                                                .afternoonSlot
                                                .slotStartTime;
                                            AendTimeController.text = tablet
                                                .afternoonSlot
                                                .slotEndTime;
                                            EstartTimeController.text = tablet
                                                .eveningSlot
                                                .slotStartTime;
                                            EendTimeController.text =
                                                tablet.eveningSlot.slotEndTime;

                                            final morningSlotSelected =
                                                tablet.morningSlot.slotSelected;
                                            final AfternoonSlotSelected = tablet
                                                .afternoonSlot
                                                .slotSelected;
                                            final EveningSlotSelected =
                                                tablet.eveningSlot.slotSelected;
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Edit Tablet Data",
                                                  ),
                                                  content: SingleChildScrollView(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            controller:
                                                                illnessTypeController,
                                                            decoration:
                                                                const InputDecoration(
                                                                  labelText:
                                                                      "Illness Type",
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                tabletNameController,
                                                            decoration:
                                                                const InputDecoration(
                                                                  labelText:
                                                                      "Tablet Name",
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                tabletFrequencyController,
                                                            decoration:
                                                                const InputDecoration(
                                                                  labelText:
                                                                      "Tablet Frequency",
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                courseDurationController,
                                                            decoration:
                                                                const InputDecoration(
                                                                  labelText:
                                                                      "Course Duration",
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          morningSlotSelected
                                                              ? Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            8.0,
                                                                          ),
                                                                      child: Text(
                                                                        "Morning Slot Timings",
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                MstartTimeController,
                                                                            decoration: InputDecoration(
                                                                              labelText: "Start Time",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width *
                                                                              0.01,
                                                                        ),
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                MendTimeController,
                                                                            decoration: InputDecoration(
                                                                              labelText: "end time",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              : Text(""),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          AfternoonSlotSelected
                                                              ? Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            8.0,
                                                                          ),
                                                                      child: Text(
                                                                        "Afternoon Slot Timings",
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                AstartTimeController,
                                                                            decoration: InputDecoration(
                                                                              labelText: "Start Time",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width *
                                                                              0.01,
                                                                        ),
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                AendTimeController,
                                                                            decoration: InputDecoration(
                                                                              labelText: "end time",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                  ],
                                                                )
                                                              : Text(""),

                                                          EveningSlotSelected
                                                              ? Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            8.0,
                                                                          ),
                                                                      child: Text(
                                                                        "Evening Slot Timings",
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                EstartTimeController,
                                                                            decoration: InputDecoration(
                                                                              labelText: "start time",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width *
                                                                              0.01,
                                                                        ),
                                                                        Expanded(
                                                                          child: TextField(
                                                                            controller:
                                                                                EendTimeController,
                                                                            decoration: InputDecoration(
                                                                              labelText: "end time",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                  ],
                                                                )
                                                              : Text(""),

                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    mSlotSelected = tablet
                                                                        .morningSlot
                                                                        .slotSelected;
                                                                    aSlotSelected = tablet
                                                                        .afternoonSlot
                                                                        .slotSelected;
                                                                    eSlotSelected = tablet
                                                                        .eveningSlot
                                                                        .slotSelected;
                                                                  });
                                                                  updateMedicalHistory(
                                                                    tablet
                                                                        .illnessType,
                                                                    tablet
                                                                        .tabletName,
                                                                    tablet
                                                                        .tabletFrequency,
                                                                    tablet
                                                                        .courseDuration,
                                                                    tablet
                                                                        .morningSlot
                                                                        .slotStartTime,
                                                                    tablet
                                                                        .morningSlot
                                                                        .slotEndTime,
                                                                    tablet
                                                                        .afternoonSlot
                                                                        .slotStartTime,
                                                                    tablet
                                                                        .afternoonSlot
                                                                        .slotEndTime,
                                                                    tablet
                                                                        .eveningSlot
                                                                        .slotStartTime,
                                                                    tablet
                                                                        .eveningSlot
                                                                        .slotStartTime,
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                      "Update",
                                                                    ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      "Cancel",
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const Text(
                                            "Edit",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Ivrpage(
                                                  tabletid: tablet.id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "IVR Screen",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
