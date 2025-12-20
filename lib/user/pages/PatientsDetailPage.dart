import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';

class Patientsdetailpage extends StatelessWidget {
  final String pid;
  const Patientsdetailpage({required this.pid, super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "Patient $pid"),
      ),
      drawer: Customdrawer(),
      body: Center(child: Text(pid)),
    );
  }
}
