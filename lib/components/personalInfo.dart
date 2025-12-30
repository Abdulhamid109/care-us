import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Personalinfo extends StatefulWidget {
  final Function(bool) allfieldEntered;
  const Personalinfo({required this.allfieldEntered, super.key});

  @override
  State<Personalinfo> createState() => _PersonalinfoState();
}

class _PersonalinfoState extends State<Personalinfo> {
  bool? isMaleSelected = false;
  bool? isFemaleSelected = false;
  TextEditingController patientName = TextEditingController();
  TextEditingController patientAge = TextEditingController();
  String? patientGender;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController Address = TextEditingController();

  void FieldsCheck() async {
    if (patientName.text.isEmpty ||
        patientAge.text.isEmpty ||
        phoneNumber.text.isEmpty ||
        Address.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kindly enter all fields"),
          backgroundColor: Colors.red,
        ),
      );
      widget.allfieldEntered(false);
    }else if (phoneNumber.text.length > 10 ||
          !phoneNumber.text.startsWith(RegExp(r'^[789][0-9]{9}$'))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Invalid phone number"),
          ),
        );
      }
    
    else {
      setState(() {
        widget.allfieldEntered(true);
      });
      await addPersonalInfo();
    }
  }

  Future<void> addPersonalInfo() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = await pref.getString("token");
      final data = JwtDecoder.decode(token!);
      print("data => ${data} and uid is ${data["uid"]}");
      print("uid => ${data["uid"]}");
      print("Name ${patientName.text}");
      print("Name ${patientAge.text}");
      print("Name ${patientGender}");
      print("Name ${phoneNumber.text}");
      print("Name ${Address.text}");

      final response = await http.post(
        Uri.parse("http://localhost:3000/api/addpatientData"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guardianId': data["uid"],
          'patientName': patientName.text,
          'patientAge': patientAge.text,
          'patientGender': patientGender,
          "phoneNumber": phoneNumber.text,
          "Address": Address.text,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pref = await SharedPreferences.getInstance();
        print("888888888888888888888");
        print(data["patient"]["_id"]);

        print("888888888888888888888");
        await pref.setString("pid", data["patient"]["_id"]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added the patients personal details..")),
        );
        Future.delayed(const Duration(seconds: 3), () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.yellow.shade200,
              shape: BeveledRectangleBorder(),
              content: SizedBox(
                height: 20,
                child: Text("Kindly Click on 'Continue' button for further proceding")),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("ok")),
                  ],
                )
              ],
            );
            
          },);
        });

        print(
          "Successfully saved the Patients Personal inforamtion = > ${response.body}",
        );
      } else {
        print(
          "Error occured with statusCode as ${response.statusCode} with ${response.body}",
        );
      }
    } catch (e) {
      print("Failed to perform the functionality ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Add Personal Data",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: patientName,
                      decoration: InputDecoration(
                        labelText: "Patient Name",
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
                      controller: patientAge,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Age",
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
                    child: Row(
                      children: [
                        Checkbox(
                          value: isMaleSelected,
                          activeColor: Colors.black,
                          onChanged: (bool? value) {
                            setState(() {
                              isMaleSelected = value;
                              patientGender = "male";
                              if (isMaleSelected!) {
                                isFemaleSelected = false;
                              }
                              print("Male selected: $isMaleSelected");
                            });
                          },
                        ),
                        Text("Male"),
                        SizedBox(width: 10),
                        Checkbox(
                          value: isFemaleSelected,
                          activeColor: Colors.black,
                          onChanged: (bool? value) {
                            setState(() {
                              print(value);
                              isFemaleSelected = value;
                              patientGender = "female";
                              if (isFemaleSelected!) {
                                isMaleSelected = false;
                                // isFemaleSelected?isFemaleSelected=false:isFemaleSelected;
                              }
                              print("FeMale selected: $isFemaleSelected");
                            });
                          },
                        ),
                        Text("Female"),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Phone no",
                        prefixText: "+91",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      validator: (value) {
                        print(value);
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: Address,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        labelText: "Address",
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
                    child: ElevatedButton(
                      onPressed: () {
                        FieldsCheck();
                      },
                      child: Text("Save Information"),
                    ),
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
