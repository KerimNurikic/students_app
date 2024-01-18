import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final Function() onExpensePressed;
  const ExpenseItem({super.key, required this.expense, required this.onExpensePressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.only(top: 4, left: 10, right: 10, bottom: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onExpensePressed,
          child: Container(
            padding: const EdgeInsets.all(25),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        expense.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        expense.date.toString().substring(0, 10),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                !expense.isBuy
                    ? const Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 15,
                      )
                    : const Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 15,
                      ),
                const SizedBox(width: 3),
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '${expense.totalExpense.toStringAsFixed(2)} KM',
                    style: TextStyle(
                      fontSize: 15,
                      color: expense.isBuy ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
