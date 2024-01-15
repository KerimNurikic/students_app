class Event{
  DateTime date;
  String title;
  String description;
  bool isToDo;
  bool? isDone;

  Event({required this.date, required this.title, required this.description, this.isToDo = false, this.isDone = false});

}