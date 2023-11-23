import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      body: const Text('Budget'),
      appBar: AppBar(
        title: const Text('Budget'),
      ),
    );
  }
}