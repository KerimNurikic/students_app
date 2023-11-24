import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/views/quotes/quote_list_item.dart';

class QuotesPanelBody extends StatelessWidget {
  final List<Quote> quotes;
  final Function(Quote) onFavoritePressed;
  final bool Function(Quote) isFavorite;

  const QuotesPanelBody({
    super.key,
    required this.quotes,
    required this.onFavoritePressed,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: quotes
                  .map((quote) => QuoteListItem(
                        quote: quote,
                        canDelete: false,
                        isFavorite: isFavorite(quote),
                        canFavorite: true,
                        onFavoritePressed: () => onFavoritePressed(quote),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text(
                  'Generate new quotes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
