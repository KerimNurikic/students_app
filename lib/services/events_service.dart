import 'package:flutter_application_1/models/event.dart';
import 'package:table_calendar/table_calendar.dart';

import './static_test_data.dart' as test_data;

class EventsService {
  static var events = test_data.events;


  List<Event> getEventsForDay(DateTime day) {
    return events.where((element) => isSameDay(day, element.date)).toList(); 
  }

  bool deleteEvent(Event event) {
    events.remove(event);
    return true;
  }
}


