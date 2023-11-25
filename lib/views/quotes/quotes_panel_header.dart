import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/constants.dart' as constants;

class QuotesPanelHeader extends StatelessWidget {
  final String quotesTitle;
  final String backgroundImage;
  final IconData iconImage;
  const QuotesPanelHeader(
      {super.key,
      required this.backgroundImage,
      required this.iconImage,
      required this.quotesTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      color: Colors.green,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.asset(constants.backgroundImages[quotesTitle],
              opacity: const AlwaysStoppedAnimation(0.8)),
          Container(
            color: Colors.black26,
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                Icon(
                  iconImage,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    quotesTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
