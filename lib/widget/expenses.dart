
import 'package:expense_tracker/widget/chart/chart.dart';
import 'package:expense_tracker/widget/expenses_lists/enpense_list.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Flutter Course",
      amount: 500.00,
      category: Category.work,
      date: DateTime.now(),
    ),
    Expense(
      title: "Movie",
      amount: 499,
      category: Category.leisure,
      date: DateTime.now(),
    ),
  ];

  void _addNewExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    // store index, for undo purpose
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context)
        .clearSnackBars(); //clear existing snackbars imediatly
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense removed."),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  void _addExpenseOption() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => NewExpense(
              addNewExpense: _addNewExpense,
            ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("No records found."),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Chart(expenses: _registeredExpenses),
            Expanded(
                child: ExpensesList(
              registeredExpense: _registeredExpenses,
              removeExpense: _removeExpense,
            )),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Align(
            alignment: Alignment.centerLeft, child: Text("Expense Tracker")),
        actions: [
          IconButton(
            onPressed: _addExpenseOption,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: mainContent,
    );
  }
}
