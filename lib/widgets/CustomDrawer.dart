import 'package:careus/user/auth/loginPage.dart';
import 'package:careus/user/pages/AddPatientsPage.dart';
import 'package:careus/user/pages/Homepage.dart';
import 'package:careus/user/pages/Profilepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customdrawer extends StatelessWidget {
  const Customdrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;
    double height = MediaQuery.of(context).size.height * 1;
    return Drawer(
      child: Column(
        children: [
          //header
          Container(
            height: height * 0.25,
            decoration: BoxDecoration(color: Colors.green.shade100),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.02),
                  Icon(
                    Icons.medical_information,
                    size: 50,
                    color: Colors.amber.shade200,
                    shadows: [
                      Shadow(
                        color: Colors.black,
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
                ],
              ),
            ),
          ),

          // Divider(),
          SizedBox(height: height * 0.01),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            ),
          ),
          SizedBox(height: height * 0.01),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profilepage()),
            ),
          ),

          SizedBox(height: height * 0.01),
          ListTile(
            leading: Icon(Icons.medical_information),
            title: Text("Add Patients"),


            // banner if needed
            // onTap: () {
            //   final messenger = ScaffoldMessenger.of(context);
            //   messenger.showMaterialBanner(
            //     MaterialBanner(
            //       content: Text("Feature under development"),
            //       actions: [
            //         TextButton(
            //           onPressed: () => messenger.hideCurrentMaterialBanner(),
            //           child: const Text('DISMISS'),
            //         ),
            //       ],
            //       backgroundColor: Colors.blueGrey[50],
            //       elevation: 4,
            //       padding: EdgeInsets.all(16),
            //     ),
            //   );
            // },
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Addpatientspage()));
            },
          ),

          SizedBox(height: height * 0.01),
          ListTile(
            title: Text("Reminder section"),
            leading: Icon(Icons.lock_clock),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("List of patients who you have set the remiders for their medicines"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(height: height * 0.01),
          ListTile(
            title: Text("About us"),
            leading: Icon(Icons.outbox_rounded),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("About us page will be developed soon"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          SizedBox(height: height * 0.01),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Center(
                      child: Text("Are you sure you want to logout?"),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("cancel"),
                              ),
                            ),

                            TextButton(
                              onPressed: () async{
                                final pref = await SharedPreferences.getInstance();
                                await pref.remove("token");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
