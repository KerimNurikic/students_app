import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';

class QuoteListItem extends StatelessWidget {

  final Quote quote;
  const QuoteListItem({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Text(quote.quoteText);
  }
}