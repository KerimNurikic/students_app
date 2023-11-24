import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/services/quotes_service.dart';
import 'package:flutter_application_1/shared/widgets/expansion_panel_no_icon.dart';
import 'package:flutter_application_1/views/quotes/quote_list_item.dart';

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

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    historyQuotes = QuotesService().getQuotesByCategory('test');
    loveQuotes = QuotesService().getQuotesByCategory('test');
    inspirationalQuotes = QuotesService().getQuotesByCategory('test');
    happinessQuotes = QuotesService().getQuotesByCategory('test');
    imaginationQuotes = QuotesService().getQuotesByCategory('test');
  }

  bool isFavorite(Quote quote) {
    return QuotesService().isFavorite(quote);
  }

  void addOrRemoveFromFavorites(Quote quote) {
    if (isFavorite(quote)) {
      QuotesService().removeFromFavorites(quote);
    } else {
      QuotesService().addToFavorites(quote);
    }

    setState(() {
      historyQuotes = QuotesService().getQuotesByCategory('test');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelListNoIcon(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanelNoIcon(
            body: SingleChildScrollView(
              child: Column(
                children: historyQuotes
                    .map((quote) => QuoteListItem(
                          quote: quote,
                          canDelete: false,
                          isFavorite: isFavorite(quote),
                          canFavorite: true,
                          onFavoritePressed: () => addOrRemoveFromFavorites(quote),
                        ))
                    .toList(),
              ),
            ),
            isExpanded: _isExpanded,
            canTapOnHeader: true,
            hasIcon: false,
            headerBuilder: (context, isExpanded) {
              return const Text('test');
            },
          ),
        ],
      ),
    );
  }
}
