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

  var isLoading = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    historyQuotes = QuotesService().getCurrentQuotes('history');
    loveQuotes = QuotesService().getCurrentQuotes('love');
    inspirationalQuotes = QuotesService().getCurrentQuotes('inspirational');
    happinessQuotes = QuotesService().getCurrentQuotes('happiness');
    imaginationQuotes = QuotesService().getCurrentQuotes('imagination');
  }

  bool isFavorite(Quote quote) {
    return QuotesService().isFavorite(quote);
  }

  void addOrRemoveFromFavorites(Quote quote) {
    if (isFavorite(quote)) {
      setState(() {
        QuotesService().removeFromFavorites(quote);
      });
    } else {
      setState(() {
        QuotesService().addToFavorites(quote);
      });
    }
  }

  void generateQuotes(String category) {
    switch (category) {
      case 'history':
        setState(() {
          isLoading[0] = true;
        });
        QuotesService()
            .fetchQuotesByCategory(category)
            .then((quotes) => setState(() {
                  historyQuotes = quotes;
                  isLoading[0] = false;
                }));
        break;
      case 'love':
        setState(() {
          isLoading[1] = true;
        });
        QuotesService()
            .fetchQuotesByCategory(category)
            .then((quotes) => setState(() {
                  loveQuotes = quotes;
                  isLoading[1] = false;
                }));
        break;
      case 'happiness':
        setState(() {
          isLoading[2] = true;
        });
        QuotesService()
            .fetchQuotesByCategory(category)
            .then((quotes) => setState(() {
                  happinessQuotes = quotes;
                  isLoading[2] = false;
                }));
        break;
      case 'inspirational':
        setState(() {
          isLoading[3] = true;
        });
        QuotesService()
            .fetchQuotesByCategory(category)
            .then((quotes) => setState(() {
                  inspirationalQuotes = quotes;
                  isLoading[3] = false;
                }));
        break;
      case 'imagination':
        setState(() {
          isLoading[4] = true;
        });
        QuotesService()
            .fetchQuotesByCategory(category)
            .then((quotes) => setState(() {
                  imaginationQuotes = quotes;
                  isLoading[4] = false;
                }));
        break;
      default:
    }
    QuotesService().fetchQuotesByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ExpansionPanelListNoIcon(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  isPanelExpanded[panelIndex] = isExpanded;
                });
              },
              children: [
                getPanel(historyQuotes, 0, 'History'),
              ],
            ),
            const SizedBox(height: 16),
            ExpansionPanelListNoIcon(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  isPanelExpanded[panelIndex + 1] = isExpanded;
                });
              },
              children: [
                getPanel(loveQuotes, 1, 'Love'),
              ],
            ),
            const SizedBox(height: 16),
            ExpansionPanelListNoIcon(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  isPanelExpanded[panelIndex + 2] = isExpanded;
                });
              },
              children: [
                getPanel(happinessQuotes, 2, 'Happiness'),
              ],
            ),
            const SizedBox(height: 16),
            ExpansionPanelListNoIcon(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  isPanelExpanded[panelIndex + 3] = isExpanded;
                });
              },
              children: [
                getPanel(inspirationalQuotes, 3, 'Inspirational'),
              ],
            ),
            const SizedBox(height: 16),
            ExpansionPanelListNoIcon(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  isPanelExpanded[panelIndex + 4] = isExpanded;
                });
              },
              children: [getPanel(imaginationQuotes, 4, 'Imagination')],
            ),
          ],
        ),
      ),
    );
  }

  ExpansionPanelNoIcon getPanel(
      List<Quote> quotes, int panelIndex, String title) {
    return ExpansionPanelNoIcon(
      body: QuotesPanelBody(
          category: title.toLowerCase(),
          isLoading: isLoading[panelIndex],
          onGenerateQuotesPressed: generateQuotes,
          quotes: quotes,
          onFavoritePressed: addOrRemoveFromFavorites,
          isFavorite: isFavorite),
      isExpanded: isPanelExpanded[panelIndex],
      canTapOnHeader: true,
      hasIcon: false,
      headerBuilder: (context, isExpanded) {
        return QuotesPanelHeader(
            backgroundImage: constants.backgroundImages[title],
            iconImage: constants.iconImages[title.toLowerCase()],
            quotesTitle: title);
      },
    );
  }
}
