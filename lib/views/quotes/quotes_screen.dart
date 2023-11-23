import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      body: const Text('Quotes'),
      appBar: AppBar(
        title: const Text('Quotes'),
      ),
    ); 
  }
}