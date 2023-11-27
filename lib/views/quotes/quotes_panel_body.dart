import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/views/quotes/quote_list_item.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QuotesPanelBody extends StatelessWidget {
  final List<Quote> quotes;
  final Function(Quote) onFavoritePressed;
  final bool Function(Quote) isFavorite;
  final bool isLoading;
  final Function(String) onGenerateQuotesPressed;
  final String category;

  const QuotesPanelBody({
    super.key,
    required this.quotes,
    required this.onFavoritePressed,
    required this.isFavorite,
    this.isLoading = false,
    required this.onGenerateQuotesPressed,
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
      child: isLoading
          ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).primaryColor, size: 50),
          )
          : SingleChildScrollView(
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
                      onPressed: () => onGenerateQuotesPressed(category),
                      icon: const Icon(Icons.restart_alt),
                      label: const Text(
                        'Generate new quotes',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
