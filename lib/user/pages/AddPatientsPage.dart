import 'dart:convert';
import 'dart:io';

import 'package:careus/components/personalInfo.dart';
import 'package:careus/components/reportsSection.dart';
import 'package:careus/components/tabletSection.dart';
import 'package:careus/constants/domain.dart';
import 'package:careus/user/pages/Homepage.dart';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Addpatientspage extends StatefulWidget {
  const Addpatientspage({super.key});

  @override
  State<Addpatientspage> createState() => _AddpatientspageState();
}

class _AddpatientspageState extends State<Addpatientspage> {
  bool? isMaleSelected = false;
  bool? isFemaleSelected = false;
  bool? errorState=false;
  int currentStep = 0;
  File? myfile;
  bool isFileSelected = false;
  String fileName = '';
  String? selectedValue = 'Morning';
  String? SlotStartTimeSelected = '';
  String? SlotendTimeSelected = '';
  TimeOfDay? stTime; //this haven't used yet
  TimeOfDay? edTime; //this haven't used yet

  Future<void> getImageFromUser() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          myfile = File(pickedFile.path);
          String filename = pickedFile.name;
          fileName = filename;
          isFileSelected = true;
        });
        print(myfile);
      } else {
        print("No image was selected.");
      }
    } catch (e) {
      print("Failed to perform the functionality => ${e}");
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "Patients Details"),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 3 &&errorState! ) {
            print("Is this Last Step ${currentStep} ${errorState}");
            setState(() {
              currentStep += 1;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Cannot proced furthur ... Kindly enter all the values!!",
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        onStepCancel: () {
          currentStep == 0
              ? null
              : setState(() {
                  currentStep -= 1;
                });
        },
        controlsBuilder: (context, details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                onPressed: currentStep < 2
                    ? details.onStepContinue
                    : () async{

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Data submitted successfully ..",
                            ),
                          ),
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Homepage()),
                          );
                        
                      },
                child: Text(currentStep < 2 ? "continue" : "Done"),
              ),

              if (currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text("Back"),
                ),
            ],
          );
        },
        steps: [
          Step(
            isActive: currentStep >= 0,
            title: Text("Personal Information"),
            content: Personalinfo(
              allfieldEntered: (bool val) {
                print("What value im getting from ahead $val");
                setState(() {
                  errorState = val;
                });
              },
            ),
          ),

          Step(
            isActive: currentStep >= 1,
            title: Text("Medical Reports"),
            content: Reportssection(),
          ),
          Step(
            isActive: currentStep >= 2,
            title: Text("Tablets Ongoing"),
            content: Tabletsection(),
          ),
        ],
      ),
    );
  }
}
