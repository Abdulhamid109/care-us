import 'dart:convert';

import 'package:careus/models/patientModal.dart';
import 'package:careus/user/pages/PatientsDetailPage.dart';
import 'package:careus/user/pages/Profilepage.dart';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Patient> allPatients = [];
  bool isLoading = true;

  Future<void> getAllUsers() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString("token");

      if (token == null) {
        print("Token is null");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final data = JwtDecoder.decode(token);
      final uid = data["uid"];

      final response = await http.get(
        Uri.parse("http://localhost:3000/api/getallpatients/$uid"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> patientsList = jsonData["Patients"];

        print("Result => ${jsonData["Patients"]}");

        setState(() {
          allPatients = patientsList
              .map((patient) => Patient.fromJson(patient))
              .toList();
          isLoading = false;
        });
      } else {
        print("Error ${response.statusCode} and ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Failed to perform the functionality: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteuser(String pid)async{
    try {
      final response = await http.delete(Uri.parse("http://localhost:3000/api/deletePatient/$pid"));
      if(response.statusCode==200){
        print("Successfully deleted the object");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Successfully deleted the Object")
          )
        );
      }else{
        print("Some Error Occured ${response.statusCode} and ");
      }
    } catch (e) {
      print("Failed to perform the functionality => $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "Care Us"),
      ),
      drawer: Customdrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Search Field
              Container(
                width: width * 0.5,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search for patients",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.05),

              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : allPatients.isEmpty
                    ? Center(child: Text("No patients found"))
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: allPatients.length,
                        itemBuilder: (context, index) {
                          final patient = allPatients[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber,
                                    offset: Offset(2, 1),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Patient Avatar
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.amber,
                                      child: Icon(
                                        patient.patientGender == "male"
                                            ? Icons.male
                                            : Icons.female,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    // Patient Name
                                    Text(
                                      patient.patientName.isEmpty
                                          ? "No Name"
                                          : patient.patientName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),

                                    // Patient Age
                                    Text(
                                      "Age: ${patient.patientAge.isEmpty ? 'N/A' : patient.patientAge}",
                                      style: TextStyle(fontSize: 14),
                                    ),

                                    // Patient Gender
                                    Text(
                                      "Gender: ${patient.patientGender}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: const Color.fromARGB(
                                              113,
                                              96,
                                              125,
                                              139,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                deleteuser(patient.id);
                                                allPatients.removeAt(index);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: const Color.fromARGB(
                                              113,
                                              96,
                                              125,
                                              139,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Patientsdetailpage(
                                                        pid: patient.id,
                                                      ),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.green,
                                            ),
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
