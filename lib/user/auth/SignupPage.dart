import 'dart:convert';
import 'dart:developer';

import 'package:careus/user/auth/OTPpage.dart';
import 'package:careus/user/auth/loginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool boolean = true;

  Future<void> signup() async {
    print("Preseed the signup button");
    print(namecontroller.text);
    print(phonecontroller.text);
    print(emailcontroller.text);
    print(passwordcontroller.text);
    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/api/auth/signup/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': namecontroller.text.toString(),
          'phoneno': phonecontroller.text.toString(),
          'email': emailcontroller.text.toLowerCase().toString(),
          'password': passwordcontroller.text.toString(),
        }),
      );
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Loginpage()),
        );
      }else{
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      log("Failed to perform the functionality");
      print("Failed to perform the functionality => ${e}");
    }
  }

  void passwordVisibilty() {
    setState(() {
      boolean = !boolean;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    double width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Create your Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: height * 0.05),

              TextField(
                controller: namecontroller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Enter your Name",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: height * 0.01),

              TextField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your Email",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: height * 0.01),

              TextField(
                controller: phonecontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: "+91",
                  hintText: "Enter your phone no",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: height * 0.01),
              TextField(
                controller: passwordcontroller,
                keyboardType: TextInputType.visiblePassword,
                obscureText: boolean,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    onPressed: passwordVisibilty,
                    icon: boolean
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
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
                  onPressed: signup,
                  //()async {
                  //   //for development only
                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(builder: (context) => Otppage()),
                  //   // );

                  // },
                  child: Text("Signup", style: TextStyle(color: Colors.black)),
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
                    TextSpan(text: "Already have an account?"),
                    TextSpan(
                      text: "login",
                      style: TextStyle(color: Colors.blueAccent.shade400),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          log(
                            "Pressed the login button navigating to signup page",
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginpage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
