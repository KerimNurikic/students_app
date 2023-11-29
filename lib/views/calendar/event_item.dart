import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/text_styles.dart';
import 'package:flutter_application_1/utils/ui_helpers.dart';
import 'package:flutter_application_1/views/calendar/event_tile.dart';

class EventItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime date;

  const EventItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    const PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                    )),
                    const PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ))
                  ])
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 50.0),
          Expanded(
            child: ListView(
              children: <Widget>[
                Hero(
                  tag: '$title${date.toString()}',
                  child: EventTile(
                    splashColor: MyColors.accent,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              title,
                              style: isThemeCurrentlyDark(context)
                                  ? TitleStylesDefault.white
                                  : TitleStylesDefault.black,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              description,
                              style: isThemeCurrentlyDark(context)
                                  ? BodyStylesDefault.white
                                  : BodyStylesDefault.black,
                              textAlign: TextAlign.left,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              date.toString().substring(0, 10),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {},
            tooltip: 'Edit quote',
            child: const Icon(Icons.edit),
          ),
          const SizedBox(
            width: 12,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {},
            tooltip: 'Delete quote',
            child: const Icon(Icons.delete),
          )
        ]),
      ),
    );
  }
}
