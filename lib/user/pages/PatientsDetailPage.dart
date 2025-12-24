import 'dart:convert';

import 'package:careus/constants/domain.dart';
import 'package:careus/models/patientModal.dart';
import 'package:careus/models/tabletsModal.dart';
import 'package:careus/user/pages/IVR.dart';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Patientsdetailpage extends StatefulWidget {
  final String pid;
  const Patientsdetailpage({required this.pid, super.key});

  @override
  State<Patientsdetailpage> createState() => _PatientsdetailpageState();
}

class _PatientsdetailpageState extends State<Patientsdetailpage> {
  Future<Map<String, dynamic>> getpersonalData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:3000/api/getPatientPersonalData/${widget.pid}",
        ),
      );
      if (response.statusCode == 200) {
        print("Successfully fetched the data from the backend");
        final jsonResponse = await jsonDecode(response.body);
        print(jsonResponse["patient"]);
        return jsonResponse;
      } else {
        print("Error at ${response.statusCode} at response ${response.body}");
      }
      throw Exception("Failed to fetch profile data");
    } catch (e) {
      print("Failed to perform the functionality $e");
      throw e;
    }
  }

  List<Tabletsmodal> mypatients = [];
  
  
  Future<void>getMedicalTablets()async{
    try {
      final response = await http.get(Uri.parse("$localhost/api/getPatientTablet/${widget.pid}"));
      if(response.statusCode==200){
        print("Data : ${response.body}");
        final jsonData = jsonDecode(response.body);
        List<dynamic> patients = jsonData["patients"];
        setState(() {
          mypatients = patients.map((patient)=>Tabletsmodal.fromJson(patient)).toList();
        });
        print("-------------------");
        print(mypatients);
        print("-------------------");
      }else{
        print("Something went wrong at ${response.statusCode} with response ${response.body}");
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
                future: getpersonalData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Name:",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!["patient"]["patientName"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Age:",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!["patient"]["patientAge"] ?? "",
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
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Phone:",
                                      style: const TextStyle(
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
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Address:",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!["patient"]["Address"] ?? "",
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
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "Gender:",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
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
                  return Text("");
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
              
                      // First Medical History Card
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: mypatients.length,
                        itemBuilder: (context, index) {
                          final data = mypatients[index];
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
                                data.illnessType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),
                              
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        "Name:",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data.TabletName,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        "Frequency:",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${data.tabletFrequencey} times a day",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        "Duration:",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${data.CourseDuration} days course",
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
                              Text(
                                "Slot Information:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                      
                              const SizedBox(height: 8),
                      
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        "Slot Section:",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data.SlotType,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        "Start-Time:",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data.StartTime,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        "End-Time:",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data.EndTime,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: BeveledRectangleBorder(
                                          borderRadius: BorderRadiusGeometry.all(Radius.circular(5))
                                        )
                                      ),
                                      
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                       builder: (context) {
                                         return AlertDialog(
                                          title: Text("Edit your data"),
                                          content: Padding(
                                            padding: EdgeInsetsGeometry.all(8),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Illness Type"
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Tablet Name"
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Tablet Frequency"
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Course duration"
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Slot Section"
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "Start time"
                                                  ),
                                                ),
                                                SizedBox(height: height*0.01,),
                                                TextField(
                                                  decoration: InputDecoration(
                                                    labelText: "End time"
                                                  ),
                                                ),
                                                SizedBox(height: height*0.02,),
                                                
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    ElevatedButton(onPressed: (){}, child: Text("update")),
                                                    ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text("cancel"))
                                                  ],
                                                )
                                              ],
                                            ),
                                            ),

                                         );
                                       },
                                       );
                                  }, 
                                  child: Text("Edit",style: TextStyle(color: Colors.white),)
                                  ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: BeveledRectangleBorder(
                                          borderRadius: BorderRadiusGeometry.all(Radius.circular(5))
                                        )
                                      ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Ivrpage(tabletid: data.id),));
                                  }, 
                                  child: Text("IVR Screen",style: TextStyle(color: Colors.white),)
                                  )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                      
                      },),
                      SizedBox(height: height * 0.02),
                                  ],
                  ),
                ),
              
              ),
            
              //Reports Card
            ],
          ),
        ),
      ),
    );
  }
}
