import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';

class QuoteListItem extends StatelessWidget {
  final Quote quote;
  final Function() onDeletePressed;
  const QuoteListItem({super.key, required this.quote, required this.onDeletePressed});

  IconData getIconFromCategory(String category){
    switch (category) {
      case 'love':
        return Icons.favorite_outline;
      case 'happiness':
        return Icons.emoji_emotions_outlined;
      case 'history':
        return Icons.history_outlined;
      case 'imagination':
        return Icons.lightbulb_outline;
      case 'inspirational':
        return Icons.all_inclusive_outlined;
      default:
        return Icons.public;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "\"${quote.quoteText}\"",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            quote.quoteAuthor,
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(width: 5),
                          Icon(getIconFromCategory(quote.quoteCategory),
                          size: 15,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: onDeletePressed,
                        ),
                      ),
                    ]),
              ]),
        ));
  }
}
