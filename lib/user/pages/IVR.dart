import 'dart:convert';

import 'package:careus/constants/domain.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:http/http.dart' as http;

class Ivrpage extends StatefulWidget {
  final String tabletid;
  const Ivrpage({required this.tabletid, super.key});

  @override
  State<Ivrpage> createState() => _IvrpageState();
}

class _IvrpageState extends State<Ivrpage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  String? morningMedStatus;
  var data = [];
  


  Future TabletDetails() async {
    try {
      final response = await http.get(
        Uri.parse("$localhost/api/tabletInfo/${widget.tabletid}"),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if(jsonData["tablet"]["MorningSlot"]["SlotSelected"]){

        }
        return jsonData;
      } else {
        print(
          "Something went wrong here ${response.statusCode} and ${response.body}",
        );
      }
    } catch (e) {
      print("Failed to perform the functionality $e");
      throw e;
    }
  }

  Future IVR() async {
    try {
      //if the call is happend today then the schema will not be created in the db hence there will be no data
      final String date =
          "${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}";
      print(date);
      final response = await http.post(
        Uri.parse("$localhost/api/getIVR/${widget.tabletid}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"date": date}),
      );

      if (response.statusCode == 200) {
        print("Response Body => " + response.body);
        final jsonData = await jsonDecode(response.body);
        
        return jsonData;
        // just check the response in every slot like in morning slot evening slot
      } else {
        print("Error Occured => ${response.statusCode} + ${response.body}");
      }
    } catch (e) {
      print("Failed to perform the functionality $e");
      throw e;
    }
  }

  Future <void> medicineStatus() async{
    try {
      //based on the slot selected and the calling hour with the current hour we are going to check if its pending,completed 
      final response = await http.get(
        Uri.parse("$localhost/api/getMorningMedStatus/${widget.tabletid}")
      );

      if(response.statusCode==200){
        final jsonData =  jsonDecode(response.body);
        print("debigginh");
        print(jsonData);
        setState(() {
          morningMedStatus = jsonData["message"];
        });
      }

    } catch (e) {
      print("Failed to perform the functionality $e");
      throw e;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "IVR"),
      ),
      drawer: Customdrawer(),
      body: Column(
  children: [
    // Calendar Container
    Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: TableCalendar(
            headerVisible: false,
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                final datas = IVR();
                print(datas);
              });
            },
            calendarFormat: CalendarFormat.week,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(fontWeight: FontWeight.w500),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    ),
    // Patient Record Section
    Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
            ),
            FutureBuilder(
              future: TabletDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(
                    "Error occurred",
                    style: TextStyle(color: Colors.red),
                  );
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Patient Record Header
                            Text(
                              "Patient Record",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue[800],
                              ),
                            ),
                            Divider(thickness: 1, color: Colors.grey[300]),
                            SizedBox(height: 10),
                            // Illness and Tablet Info
                            Row(
                              children: [
                                Icon(Icons.medical_services, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  snapshot.data["tablet"]["illnessType"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.medication, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  snapshot.data["tablet"]["tabletName"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Morning Slot
                            snapshot.data["tablet"]["MorningSlot"]["SlotSelected"]
                                ? Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Morning Slot",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "Start: ${snapshot.data["tablet"]["MorningSlot"]["SlotStartTime"]}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "End: ${snapshot.data["tablet"]["MorningSlot"]["SlotEndTime"]}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Status: $morningMedStatus",
                                                    style: TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(color: Colors.blue),
                                                ),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.blue[50],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      "Morning Slot not available",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                            // Afternoon Slot
                            snapshot.data["tablet"]["AfternoonSlot"]["SlotSelected"]
                                ? Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Afternoon Slot",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "Start: ${snapshot.data["tablet"]["AfternoonSlot"]["SlotStartTime"]}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "End: ${snapshot.data["tablet"]["AfternoonSlot"]["SlotEndTime"]}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Status: $morningMedStatus",
                                                    style: TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(color: Colors.blue),
                                                ),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.blue[50],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      "Afternoon Slot not available",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                            // Evening Slot
                            snapshot.data["tablet"]["EveningSlot"]["SlotSelected"]
                                ? Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Evening Slot",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "Start: ${snapshot.data["tablet"]["EveningSlot"]["SlotStartTime"]}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                                              SizedBox(width: 8),
                                              Text(
                                                "End: ${snapshot.data["tablet"]["EveningSlot"]["SlotEndTime"]}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Status: $morningMedStatus",
                                                    style: TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(color: Colors.blue),
                                                ),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.blue[50],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      "Evening Slot not available",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    ),
  ],
)

    );
  }
}
