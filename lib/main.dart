import 'package:careus/user/auth/loginPage.dart';
import 'package:careus/user/pages/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp( MyApp(token: pref.getString("token"),));
}

class MyApp extends StatelessWidget{
  final String? token;
  const MyApp({super.key,required this.token});

  @override
  Widget build(BuildContext context) {
    bool isTokenValid = token != null && !JwtDecoder.isExpired(token!);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: isTokenValid?Homepage():Loginpage(),
    );
    
  }
}