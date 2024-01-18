
class Expense {
  Map<String, double> itemsBought;

  double totalExpense;
  DateTime date;
  bool isBuy;
  String description;

  Expense(
      {required this.date,
      required this.description,
      required this.isBuy,
      this.itemsBought = const {},
      required this.totalExpense});
}
