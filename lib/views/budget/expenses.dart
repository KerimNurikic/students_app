import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/services/expenses_service.dart';
import 'package:flutter_application_1/views/budget/expense_item.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  double totalMoney = 0;
  List<Expense> expenses = <Expense>[];

  @override
  void initState() {
    super.initState();
    totalMoney = ExpensesService().getTotalBudget();
    expenses = ExpensesService().getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddIncomeDialog(),
        label: const Text('Add Income'),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 25),
            padding: const EdgeInsets.all(25),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'YOUR TOTAL BUDGET',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalMoney.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'KM',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                const Icon(Icons.euro, size: 60, color: Colors.white),
              ],
            ),
          ),
          const Divider(),
          Column(
            children: expenses
                .map((e) => ExpenseItem(
                    expense: e, onExpensePressed: () => openExpenseDialog(e)))
                .toList(),
          )
        ],
      ),
    );
  }

  void _openAddIncomeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final incomeController = TextEditingController();
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
                    _addIncome(Expense(
                        date: DateTime.now(),
                        description: descriptionController.text,
                        isBuy: false,
                        totalExpense:
                            double.tryParse(incomeController.text) ?? 0));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Income'),
                )
              ],
              contentPadding: EdgeInsets.zero,
              scrollable: true,
              title: const Text(
                'Add income',
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
                        hintText: 'Description',
                      ),
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^\d*\.?\d*)'))
                      ],
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Amount',
                      ),
                      controller: incomeController,
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _addIncome(Expense expense) {
    if (expense.totalExpense <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Income has to be greater than 0'),
        ),
      );
    } else if (expense.description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description can\'t be empty'),
        ),
      );
    } else {
      ExpensesService().addIncome(expense);
      setState(() {});
    }
  }

  void openExpenseDialog(Expense expense) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            title: Text(
              expense.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
            ),
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                tag: '${expense.description}${expense.date.toString()}',
                child: Column(
                  children: [
                    Column(
                        children: expense.isBuy
                            ? [
                                Column(
                                    children: expense.itemsBought.entries
                                        .map(
                                          (e) => Row(
                                            children: [
                                              Text('${e.key}: '),
                                              Text(
                                                  '${e.value.toStringAsFixed(2)} KM'),
                                            ],
                                          ),
                                        )
                                        .toList()),
                                const SizedBox(
                                  height: 10.0,
                                )
                              ]
                            : []),
                    Text(
                      '${expense.isBuy ? 'Total expense: ' : 'Total income: '}${expense.totalExpense.toStringAsFixed(2)} KM',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      expense.date.toString().substring(0, 10),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
