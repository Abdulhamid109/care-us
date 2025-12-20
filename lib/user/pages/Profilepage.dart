import 'dart:convert';
import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  Future<Map<String, dynamic>>? _profileDataFuture;
  // Map<String, dynamic>? _profileData;

  // Controllers for editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileDataFuture = getProfileData();
  }

  Future<Map<String, dynamic>> getProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse("http://localhost:3000/api/profile"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"token": prefs.getString("token")}),
      );
      if (response.statusCode == 200) {
        final jResponse = jsonDecode(response.body);
        // _profileData = jResponse;
        return jResponse;
      }
      throw Exception("Failed to fetch profile data");
    } catch (e) {
      print("Failed to fetch profile data: $e");
      throw e;
    }
  }

  Future<void> updateProfile(
    String id,
    String name,
    String email,
    String? address,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/api/updateprofile/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text.isEmpty ? name : nameController.text,
          'email': emailController.text.isEmpty
              ? email
              : emailController.text.toLowerCase(),
          'address': addressController.text.isEmpty
              ? address
              : addressController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade200,
            duration: Duration(seconds: 2),
            content: Text("Successfully updated the profile details"),
          ),
        );

        // Refresh the profile data
        setState(() {
          _profileDataFuture = getProfileData();
        });

        Navigator.pop(context);
      } else {
        print("Error ${response.body} with status code ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to update profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "Profile"),
      ),
      drawer: Customdrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.05),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 24,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),

            FutureBuilder<Map<String, dynamic>>(
              future: _profileDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  // Pre-fill controllers with current data
                  nameController.text = snapshot.data!["user"]["name"] ?? "";
                  emailController.text = snapshot.data!["user"]["email"] ?? "";
                  addressController.text =
                      snapshot.data!["user"]["address"] ?? "";

                  return Column(
                    children: [
                      Text(
                        snapshot.data!["user"]["name"] ?? "",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: height * 0.01),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Name Field
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: Colors.blue.shade800,
                                        size: 24,
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            snapshot.data!["user"]["name"] ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 1, color: Colors.grey.shade300),

                                // Email Field
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: Colors.blue.shade800,
                                        size: 24,
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            snapshot.data!["user"]["email"] ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 1, color: Colors.grey.shade300),

                                // Phone Field
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone_outlined,
                                        color: Colors.blue.shade800,
                                        size: 24,
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Phone",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "+91 ${snapshot.data!["user"]["phoneno"] ?? ""}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 1, color: Colors.grey.shade300),

                                // Address Field
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.blue.shade800,
                                        size: 24,
                                      ),
                                      SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Address (Optional)",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            snapshot.data!["user"]["address"] ??
                                                "Thane",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Update your profile data",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                icon: Icon(Icons.edit),
                                shape: BeveledRectangleBorder(),
                                content: SizedBox(
                                  height: height * 0.5,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText:
                                              snapshot.data!["user"]["name"] ??
                                              "",
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          hintText:
                                              snapshot.data!["user"]["email"] ??
                                              "",
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          hintText:
                                              "+91 ${snapshot.data!["user"]["phoneno"] ?? ""}",
                                        ),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      TextField(
                                        controller: addressController,
                                        decoration: InputDecoration(
                                          hintText:
                                              snapshot
                                                  .data!["user"]["address"] ??
                                              "Enter your address",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.red.shade100,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.shade200,
                                        ),
                                        onPressed: () async {
                                          await updateProfile(
                                            snapshot.data!["user"]["_id"],
                                            snapshot.data!["user"]["name"],
                                            snapshot.data!["user"]["email"],
                                            snapshot.data!["user"]["address"] ??
                                                "Thane",
                                          );
                                        },
                                        child: Text("Update"),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit_outlined),
                        label: Text("Edit Profile"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width * 0.5, height * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Text("");
              },
            ),
          ],
        ),
      ),
    );
  }
}
