import 'package:careus/widgets/CustomAppbar.dart';
import 'package:careus/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Ivrpage extends StatefulWidget {
  final String tabletid;
  const Ivrpage({required this.tabletid, super.key});

  @override
  State<Ivrpage> createState() => _IvrpageState();
}

class _IvrpageState extends State<Ivrpage> {
  DateTime selectedDay = DateTime.now();
  final List<String> fixedEvents = [
    "Morning Medication",
    "Afternoon Checkup",
    "Evening Exercise",
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Customappbar(ScreenTitle: "IVR"),
      ),
      drawer: Customdrawer(),

      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2025, 12, 16),
            lastDay: DateTime.utc(2026, 1, 14),
            
          ),
        ],
      ),
    );
  }
}
