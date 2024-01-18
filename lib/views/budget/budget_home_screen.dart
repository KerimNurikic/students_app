import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/views/budget/budget_screen.dart';
import 'package:flutter_application_1/views/budget/expenses.dart';

class BudgetHomeScreen extends StatefulWidget {
  const BudgetHomeScreen({super.key});

  @override
  State<BudgetHomeScreen> createState() => _BudgetHomeScreenState();
}

class _BudgetHomeScreenState extends State<BudgetHomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      body: currentPageIndex == 0
          ? const Expenses()
          : BudgetScreen(
              changePage: () => {
                setState(() {
                  currentPageIndex = 0;
                })
              },
            ),
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).primaryColor,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.feed),
            icon: Icon(Icons.feed_outlined),
            label: 'My Budget',
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.camera_alt),
              icon: Icon(Icons.camera_alt_outlined),
              label: 'Scan'),
        ],
      ),
    );
  }
}
