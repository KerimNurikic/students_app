import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/budget/budget_home_screen.dart';
import 'package:flutter_application_1/views/calendar/calendar_screen.dart';
import 'package:flutter_application_1/views/quotes/quotes_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BudgetHomeScreen(),
    );
  }
}

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeaders(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeaders(BuildContext context) => Material(
        color: Colors.blueGrey,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 24,
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 52,
                  backgroundImage: AssetImage('assets/images/student_avatar.png'),
                ),
                SizedBox(height: 12),
                Text(
                  'Amra Trako',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text('trakoamra99@gmail.com',
                    style: TextStyle(fontSize: 16, color: Colors.white))
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: const Text('Budget'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const BudgetHomeScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Calendar'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const CalendarScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.format_quote_outlined),
            title: const Text('Quotes'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const QuotesScreen())),
          ),
        ],
      );
}
