import 'package:flutter/material.dart';

class FavoriteQuotes extends StatefulWidget {
  const FavoriteQuotes({super.key});

  @override
  State<FavoriteQuotes> createState() => _FavoriteQuotesState();
}

class _FavoriteQuotesState extends State<FavoriteQuotes> {
  @override
  Widget build(BuildContext context) {
    return const Text('Favorite quotes');
  }
}