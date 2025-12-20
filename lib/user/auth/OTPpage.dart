import 'package:flutter/material.dart';



class Otppage extends StatelessWidget{
  const Otppage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height*1;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: double.infinity,
                    child: Text("Resend OTP",
                    textAlign: TextAlign.right,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
          
                 Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.blueAccent.shade200,
                    ),
                    onPressed: () {
                      
                    },
                    child: Text("Verify OTP", style: TextStyle(color: Colors.black)),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
    
  }
}