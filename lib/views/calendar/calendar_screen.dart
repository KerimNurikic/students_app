import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      body: const Text('Calendar'),
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
    );
  }
}