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
      int index = favoriteQuotes.indexOf(quote);
      if (QuotesService().removeFromFavorites(quote)) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Quote removed from favorites!"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  setState(() {
                    QuotesService().addToFavorites(quote, index);
                  });
                })));
      }
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
