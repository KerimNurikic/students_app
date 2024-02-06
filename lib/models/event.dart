class Event{
  DateTime date;
  String title;
  String description;
  bool isToDo;
  bool? isDone;

  Event({required this.date, required this.title, required this.description, this.isToDo = false, this.isDone = false});

  Map<String, dynamic> toMap(){
    return {
      'date': date,
      'title': title,
      'description': description,
      'isToDo': isToDo ? 1 : 0,
      'isDone': isDone ?? 0
    };
  }

}