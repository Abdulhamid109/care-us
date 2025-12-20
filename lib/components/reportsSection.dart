// In order to send multipart data using http package on web its not possible unless and until you convert it into bytes
// hence waiting for using physical device or android emulator for it.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reportssection extends StatefulWidget {
  const Reportssection({super.key});

  @override
  State<Reportssection> createState() => _ReportssectionState();
}

class _ReportssectionState extends State<Reportssection> {
  int currentStep = 0;
  File? myfile;
  bool isFileSelected = false;
  String fileName = '';
  TextEditingController reportName = TextEditingController();
  TextEditingController HospitalName = TextEditingController();

  Future<File?> getImageFromUser() async {
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
        return myfile;
      } else {
        print("No image was selected.");
      }
    } catch (e) {
      print("Failed to perform the functionality => ${e}");
    }
  }

  // Future<void> addReportData() async {
  //   try {
  //     FormData formData = FormData.fromMap({
  //       'file': await MultipartFile.fromFile(myfile!.path),
  //       'reportName': reportName.text.toString(),
  //       'HospitalName': HospitalName.text.toString(),
  //     });

  //     final dio = Dio();
  //     final response = await dio.post(
  //       'http://localhost:3000/api/addreports',
  //       data: formData,
  //       options: Options(headers: {'Content-Type': 'multipart/form-data'}),
  //     );

  //     if(response.statusCode==200){
  //       print("Success => ${response.data}");
  //     }else{
  //       print("Error with response code => ${response.statusCode} and ${response}");
  //     }
  //   } catch (e) {
  //     print("Failed to perform the functionality $e");
  //   }
  // }

  Future<void> addReportData() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final tokendata = await pref.getString("token");
      final pid = await pref.getString("pid");
      final decodedData = JwtDecoder.decode(tokendata!);
      var uri = Uri.parse("http://localhost:3000/api/addreports");
      var request = http.MultipartRequest('POST', uri);
      request.fields["GuardianId"] = decodedData["uid"];
      request.fields["patientId"] = pid!;
      request.fields["reportName"] = reportName.text.toString();
      request.fields["HospitalName"] = HospitalName.text.toString();
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          myfile!.path,
          filename: fileName,
        ),
      );
      request.headers.addAll({
        "Content-Type": "multipart/form-data"
      });

      var response = await request.send();

      if(response.statusCode==200){
        print("Successfully saved data to db ${response}");
      }else{
        print("Something went wrong ${response} statuscode ${response.statusCode}");
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Reports Data",
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
                controller: reportName,
                decoration: InputDecoration(
                  labelText: "ReportName",
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
                controller: HospitalName,
                decoration: InputDecoration(
                  labelText: "Hospital Name",
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

            isFileSelected
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: BeveledRectangleBorder(),
                        ),
                        onPressed: () {
                          getImageFromUser();
                        },
                        child: Text(
                          "Selected File: $fileName",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          getImageFromUser();
                        },
                        child: Text(
                          "Select File",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await addReportData();
                    },
                    child: Text("Save Report"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Add new Report"),
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
