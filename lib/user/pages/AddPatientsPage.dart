import 'dart:io';

import 'package:careus/components/personalInfo.dart';
import 'package:careus/components/reportsSection.dart';
import 'package:careus/components/tabletSection.dart';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addpatientspage extends StatefulWidget {
  const Addpatientspage({super.key});

  @override
  State<Addpatientspage> createState() => _AddpatientspageState();
}

class _AddpatientspageState extends State<Addpatientspage> {
  bool? isMaleSelected = false;
  bool? isFemaleSelected = false;
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "Patients Details"),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 3) {
            print("Is this Last Step ${currentStep}");
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          currentStep == 0
              ? null
              : setState(() {
                  currentStep -= 1;
                });
        },
        onStepTapped: (value) {
          setState(() {
            currentStep = value;
          });
        },
        steps: [
          Step(
            isActive: currentStep >= 0,
            title: Text("Personal Information"),
            content: Personalinfo(),
          ),

          Step(
            isActive: currentStep >= 1,
            title: Text("Medical Reports"),
            content: Reportssection()
          ),
          Step(
            isActive: currentStep >= 2,
            title: Text("Tablets Ongoing"),
            content: Tabletsection()
          ),
        ],
      ),
    );
  }
}
