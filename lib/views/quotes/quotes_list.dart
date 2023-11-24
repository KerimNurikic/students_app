import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/services/quotes_service.dart';
import 'package:flutter_application_1/shared/widgets/expansion_panel_no_icon.dart';
import 'package:flutter_application_1/views/quotes/quotes_panel_body.dart';
import 'package:flutter_application_1/views/quotes/quotes_panel_header.dart';
import 'package:flutter_application_1/shared/constants.dart' as constants;

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

  var isPanelExpanded = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    historyQuotes = QuotesService().getQuotesByCategory('history');
    loveQuotes = QuotesService().getQuotesByCategory('love');
    inspirationalQuotes = QuotesService().getQuotesByCategory('inspirational');
    happinessQuotes = QuotesService().getQuotesByCategory('happiness');
    imaginationQuotes = QuotesService().getQuotesByCategory('imagination');
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
      //historyQuotes = QuotesService().getQuotesByCategory('test');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionPanelListNoIcon(
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              isPanelExpanded[panelIndex] = isExpanded;
            });
          },
          children: [
            getPanel(historyQuotes, 0, 'History'),
            getPanel(loveQuotes, 1, 'Love'),
            getPanel(happinessQuotes, 2, 'Happiness'),
            getPanel(inspirationalQuotes, 3, 'Inspirational'),
            getPanel(imaginationQuotes, 4, 'Imagination')
          ],
        ),
      ),
    );
  }

  ExpansionPanelNoIcon getPanel(
      List<Quote> quotes, int panelIndex, String title) {
    return ExpansionPanelNoIcon(
      body: QuotesPanelBody(
          quotes: quotes,
          onFavoritePressed: addOrRemoveFromFavorites,
          isFavorite: isFavorite),
      isExpanded: isPanelExpanded[panelIndex],
      canTapOnHeader: true,
      hasIcon: false,
      headerBuilder: (context, isExpanded) {
        return QuotesPanelHeader(
            backgroundImage: constants.backgroundImages[title],
            iconImage: constants.iconImages[title],
            quotesTitle: title);
      },
    );
  }
}
