import 'package:careus/user/auth/loginPage.dart';
import 'package:careus/user/pages/Profilepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customappbar extends StatelessWidget {
  final String ScreenTitle;
  const Customappbar({super.key,required this.ScreenTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text("${ScreenTitle}"),
        centerTitle: true,
        actions: [
          //  DropdownButton(
          //     value: selectedValue,
          //     items: [
          //       DropdownMenuItem(value: "Profile", child: Text("Profile")),
          //       DropdownMenuItem(value: "Logout", child: Text("Logout")),
          //     ],
          //     onChanged: (val) {
          //       print(val);
          //       setState(() {
          //         selectedValue = val;
          //       });
    
          //
          //
          //     },
          //   ),
          PopupMenuButton(
            tooltip: "Click ",
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(value: "Profile", child: Text("Profile")),
              PopupMenuItem<String>(value: "Logout", child: Text("Logout")),
            ],
            onSelected: (val) {
              if (val == "Profile") {
                print("Profile tapped");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profilepage()),
                );
              }
    
              if (val == "Logout") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(7),
                        ),
                      ),
                      title: Text("Are you sure you want to logout"),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async{
                                 final pref = await SharedPreferences.getInstance();
                                await pref.remove("token");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
                              
                              },
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
        elevation: 10,
      );
      
  }
}