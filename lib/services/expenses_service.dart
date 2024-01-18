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

  bool addIncome(Expense expense){
    expensesList.insert(0, expense);
    totalBudget = totalBudget + expense.totalExpense;
    return true;
  }

  bool addExpense(Expense expense){
    expensesList.insert(0, expense);
    totalBudget = totalBudget - expense.totalExpense;
    return true;
  }

}