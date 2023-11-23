import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/quote.dart';
import 'package:flutter_application_1/services/quotes_service.dart';
import 'package:flutter_application_1/shared/widgets/expansion_panel_no_icon.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: ExpansionPanelListNoIcon(
          expansionCallback: (panelIndex, isExpanded)  {
            setState(() {
              _isExpanded = isExpanded;
            });
          },
          children: [
            ExpansionPanelNoIcon(
              body: Text('test'),
              isExpanded: _isExpanded,
              canTapOnHeader: true,
              hasIcon: false,
              headerBuilder: (context, isExpanded) {
                return Image(image: NetworkImage('https://thumbs.dreamstime.com/b/sun-rays-mountain-landscape-5721010.jpg'),
                opacity: AlwaysStoppedAnimation(.5),);
              },
            ),
          ],
        ),
      ),
    );
  }
}
