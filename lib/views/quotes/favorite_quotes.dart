import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/services/quotes_service.dart';
import 'package:flutter_application_1/views/quotes/quote_list_item.dart';

class FavoriteQuotes extends StatefulWidget {
  const FavoriteQuotes({super.key});

  @override
  State<FavoriteQuotes> createState() => _FavoriteQuotesState();
}

class _FavoriteQuotesState extends State<FavoriteQuotes> {
  var favoriteQuotes = <Quote>[];

  @override
  void initState() {
    super.initState();
    favoriteQuotes = QuotesService().getFavoriteQuotes();
  }

  void removeQuoteFromFavorites(Quote quote) {
    setState(() {
      favoriteQuotes.remove(quote);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: favoriteQuotes
            .map((quote) => QuoteListItem(
                  quote: quote,
                  onDeletePressed: () => removeQuoteFromFavorites(quote),
                ))
            .toList(),
      ),
    );
  }
}
