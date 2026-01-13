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

  Future TabletDetails() async {
    try {
      final response = await http.get(
        Uri.parse("$localhost/api/tabletInfo/${widget.tabletid}"),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
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
        // just check the response in every slot like in morning slot evening slot
      } else {
        print("Error Occured => ${response.statusCode} + ${response.body}");
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
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      IVR();
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
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder(
                    future: TabletDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error happend");
                      } else if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  shadowColor: Colors.black,
                                  elevation: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "Patient Record",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data["tablet"]["illnessType"],
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data["tablet"]["tabletName"],
                                                  ),
                                                  //checcking the morning slot and accordingly updating the 
                                                  snapshot.data["tablet"]["MorningSlot"]["SlotSelected"]?
                                                  SizedBox(
                                                    width: 402,
                                                    child: Text("Morning slot is selected => user can see that it should display either pending(check for call schedule time and current time),done(if the status is updated => if call status is true),failed(send the message to guradian)->for tablets",style: TextStyle(fontSize: 15),))
                                                  :Text("")
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.green.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          5.0,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Took Medicine",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Icon(
                                                          Icons.check,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.blue,
                                                      ),
                                                  onPressed: () {},
                                                  child: Text(
                                                    "Update Status",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Text("");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
