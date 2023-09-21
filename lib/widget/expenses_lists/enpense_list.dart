import 'package:expense_tracker/widget/expenses_lists/expenses_items.dart';
import 'package:flutter/material.dart';

import '../../model/expense_model.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> registeredExpense;
  final void Function(Expense expense) removeExpense;
  const ExpensesList(
      {super.key,
      required this.registeredExpense,
      required this.removeExpense});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: registeredExpense.length,
      itemBuilder: ((context, index) => Dismissible(
            key: ValueKey(registeredExpense[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
            ),
            onDismissed: (dismissDirection) {
              removeExpense(registeredExpense[index]);
            },
            child: ExpenseItems(expense: registeredExpense[index]),
          )),
    );
  }
}
