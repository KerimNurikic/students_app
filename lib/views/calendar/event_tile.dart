import 'package:flutter_application_1/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.child,
    required this.splashColor,
  });
  final Widget child;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(15.0),
        shadowColor: shadowColor(context),
        child: InkWell(
          splashColor: splashColor,
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {},
          child: child,
        ),
      ),
    );
  }
}
