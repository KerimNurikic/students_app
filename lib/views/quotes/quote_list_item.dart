import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/shared/constants.dart' as constants;

class QuoteListItem extends StatelessWidget {
  final Quote quote;
  final Function()? onDeletePressed;
  final Function()? onFavoritePressed;
  final bool isFavorite;
  final bool canFavorite;
  final bool canDelete;
  const QuoteListItem(
      {super.key,
      required this.quote,
      this.onDeletePressed,
      this.onFavoritePressed,
      this.canFavorite = false,
      this.isFavorite = false,
      this.canDelete = true});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side:
                BorderSide(color: Theme.of(context).primaryColor, width: 0.2)),
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 8.0),
                Text(
                  "\"${quote.quoteText}\"",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "- ${quote.quoteAuthor}",
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            constants.iconImages[quote.quoteCategory],
                            size: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      Container(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              if (canFavorite)
                                IconButton(
                                  icon: isFavorite
                                      ? Icon(
                                          Icons.favorite,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Icon(
                                          Icons.favorite_outline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  onPressed: onFavoritePressed,
                                  tooltip: isFavorite
                                      ? 'Remove from favorites'
                                      : 'Add to favorites',
                                ),
                              if (canDelete)
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: onDeletePressed,
                                  tooltip: 'Remove',
                                  color: const Color(0xffc70000),
                                ),
                            ],
                          )),
                    ]),
              ]),
        ));
  }
}
