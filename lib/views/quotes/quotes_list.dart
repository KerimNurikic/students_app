import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/services/quotes_service.dart';

class QuotesList extends StatefulWidget {
  const QuotesList({super.key});

  @override
  State<QuotesList> createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {

  var historyQuotes = <Quote>[];
  var loveQuotes = <Quote>[];
  var inspirationalQuotes = <Quote>[];
  var happinessQuotes = <Quote>[];
  var imaginationQuotes = <Quote>[];

  @override
  void initState(){
    super.initState();
    historyQuotes = QuotesService().getQuotesByCategory('test');
    loveQuotes = QuotesService().getQuotesByCategory('test');
    inspirationalQuotes = QuotesService().getQuotesByCategory('test');
    happinessQuotes = QuotesService().getQuotesByCategory('test');
    imaginationQuotes = QuotesService().getQuotesByCategory('test');
  }

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}