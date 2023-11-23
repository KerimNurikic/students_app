import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/views/quotes/favorite_quotes.dart';
import 'package:flutter_application_1/views/quotes/quotes_list.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      body: currentPageIndex == 0 ? const QuotesList() : const FavoriteQuotes(),
      appBar: AppBar(
        title: const Text('Quotes'),
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
            selectedIcon: Icon(Icons.my_library_books),
            icon: Icon(Icons.my_library_books_outlined), 
            label: 'Quotes'
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline), 
            label: 'My Quotes',
          ),
        ],
      ),
    ); 
  }
}
