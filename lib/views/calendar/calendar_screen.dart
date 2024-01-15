import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/event.dart';
import 'package:flutter_application_1/services/events_service.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return EventsService().getEventsForDay(day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _addEvent(Event event) {
    EventsService().addEvent(event);
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
    setState(() {});
  }

  void _openAddEventDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bool? isToDo = false;
          final titleController = TextEditingController();
          final descriptionController = TextEditingController();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('Close', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    _addEvent(Event(
                        date: _focusedDay,
                        title: titleController.text,
                        description: descriptionController.text,
                        isToDo: isToDo ?? false));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Note'),
                )
              ],
              contentPadding: EdgeInsets.zero,
              scrollable: true,
              title: const Text(
                'Add note',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
              ),
              content: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Note title',
                      ),
                      controller: titleController,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Note description',
                      ),
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(' To-Do: '),
                        Checkbox(
                          value: isToDo,
                          onChanged: (bool? selected) {
                            setState(() {
                              isToDo = selected;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void _deleteEvent(Event event) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${event.title}"?'),
        content: const Text('This action will permanently delete the note'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white))),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );

    if (result == null || !result) {
      return;
    }

    EventsService().deleteEvent(event);
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
    setState(() {});
  }

  void openEventDialog(Event event) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            title: Text(
              event.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
            ),
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                tag: '${event.title}${event.date.toString()}',
                child: Column(
                  children: [
                    Text(
                      event.description,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      event.date.toString().substring(0, 10),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyNavigationDrawer(),
      body: Column(
        children: [
          TableCalendar(
            pageJumpingEnabled: true,
            focusedDay: _focusedDay,
            firstDay: DateTime(2022),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(outsideDaysVisible: false),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) => {
              if (_calendarFormat != format)
                {
                  setState(() {
                    _calendarFormat = format;
                  })
                }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 12.0),
          const Divider(),
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Hero(
                              tag:
                                  '${value[index].title}${value[index].date.toString()}',
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  
                                  leading: value[index].isToDo
                                      ? Checkbox(
                                          value: value[index].isDone,
                                          onChanged: (bool? selected) {
                                            setState(() {
                                              value[index].isDone = selected;
                                            });
                                          },
                                        )
                                      : null,
                                  onTap: () => openEventDialog(value[index]),
                                  title: Text(value[index].title),
                                  subtitle: Text(
                                    value[index].description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () =>
                                                _deleteEvent(value[index]),
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ))
                                      ]),
                                ),
                              ),
                            ),
                          );
                        });
                  }))
        ],
      ),
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddEventDialog(),
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
