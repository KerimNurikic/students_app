import 'package:flutter/material.dart';

class QuotesPanelHeader extends StatelessWidget {
  final String quotesTitle;
  final String backgroundImage;
  final String iconImage;
  const QuotesPanelHeader(
      {super.key,
      required this.backgroundImage,
      required this.iconImage,
      required this.quotesTitle});

  @override
  Widget build(BuildContext context) {
    return Text(quotesTitle);
  }
}
