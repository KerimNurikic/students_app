import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/views/quotes/quote_list_item.dart';

class QuotesList extends StatefulWidget {
  const QuotesList({super.key});

  @override
  State<QuotesList> createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {

  var quotes = <Quote>[
    Quote(quoteText: 'Prvi quote', quoteTitle: 'Naslov prvi'),
    Quote(quoteText: 'Drugi quote', quoteTitle: 'Naslov drugi'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: quotes.map((quote) => QuoteListItem(quote: quote)).toList(),
    );
  }
}