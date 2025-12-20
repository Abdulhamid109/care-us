import 'dart:convert';
import 'dart:developer';

import 'package:careus/user/auth/SignupPage.dart';
import 'package:careus/user/pages/Homepage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController phonecontroller = TextEditingController();
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    shared_preferences_state();
  }

  void shared_preferences_state() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/api/auth/login/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneno': phonecontroller.text.toString()}),
      );

      if (response.statusCode == 200) {
        var decodedbody = jsonDecode(response.body);
        pref.setString("token", decodedbody["token"]);
        print("Token Data => ${decodedbody["token"]}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successfully logged in...redirecting to homepage"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } else {
        print(
          "Some Error happened with code as ${response.statusCode} => ${response.body} ",
        );
        var error = jsonDecode(response.body);
        final messenger = ScaffoldMessenger.of(context);
        messenger.showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.red.shade200,
            leading: Icon(Icons.error, color: Colors.red),
            content: Text(error["error"]),
            actions: [
              TextButton(
                onPressed: () {
                  messenger.hideCurrentMaterialBanner();
                },
                child: Text(
                  "Dismiss",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        );
        Future.delayed(Duration(seconds: 5), () {
          if (messenger.mounted) {
            messenger.hideCurrentMaterialBanner();
          }
        });
      }
    } catch (e) {
      print("Failed to perform the functionaloty => ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    double width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.1),
            Icon(
              Icons.medical_information,
              size: 50,
              shadows: [
                Shadow(
                  color: Colors.amberAccent,
                  offset: Offset(2, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Care Us",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.02),
            Center(
              child: Text(
                "A place where your loved ones receive the care they deserve.",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.1),

            //textfield
            TextField(
              controller: phonecontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "+91",
                hintText: "Enter your registered phone no",
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.blueAccent.shade200,
                ),
                onPressed: login,
                child: Text("Login", style: TextStyle(color: Colors.black)),
              ),
            ),

            SizedBox(height: height * 0.06),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Or"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Don't have an account?"),
                  TextSpan(
                    text: "SignUp",
                    style: TextStyle(color: Colors.blueAccent.shade400),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        log(
                          "Pressed the Signup button navigating to signup page",
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signuppage()),
                        );
                      },
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
