import 'dart:collection';

import 'package:flutter_application_1/models/expense.dart';

import './static_test_data.dart' as test_data;

class ExpensesService{

  static var expensesList = test_data.expenses;
  static var totalBudget = test_data.totalBudget;

  double getTotalBudget(){
    return totalBudget;
  }

  List<Expense> getExpenses(){
    return expensesList;
  }

}