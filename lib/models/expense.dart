class Expense {
  Map<String, double>? itemsBought;

  double totalExpense;
  DateTime date;
  bool isBuy;
  String description;

  Expense(
      {required this.date,
      this.itemsBought,
      required this.description,
      required this.isBuy,
      required this.totalExpense});
}
