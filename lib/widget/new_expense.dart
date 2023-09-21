import 'package:expense_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addNewExpense});

  final void Function(Expense newExpense) addNewExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _pickedDate;
  Category _selectedCategory = Category.food;

  void _submitNewExpense() {
    var amount = double.tryParse(_amountController.text);
    final bool isAmountFieldInValid = amount == null || amount <= 0;

    if (_titleController.text.trim().isEmpty ||
        _pickedDate == null ||
        isAmountFieldInValid) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Invalid Input"),
              content: const Text(
                  "Do fill all the required field with correct data according to field type."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("close"))
              ],
            );
          });
      return; //if "if" stament hits then it must not exceute further code after if
    }
    //after if

    widget.addNewExpense(Expense(
        title: _titleController.text,
        amount: amount,
        category: _selectedCategory,
        date: _pickedDate!));
    Navigator.pop(context);
  }

  void _datePicker() async {
    final initial = DateTime.now();
    final first = DateTime(initial.year - 18, initial.month, initial.day);
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: first,
        lastDate: initial);

    setState(() {
      _pickedDate = selectedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 20,
            decoration: const InputDecoration(
              label: Text("Title"),
            ),
          ),
        //input amount
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text("Amount"),
                    prefixText: "\$ ",
                  ),
                ),
              ),

              // date picker
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _pickedDate == null
                          ? "Select Date"
                          : formater.format(_pickedDate!),
                    ),
                    const VerticalDivider(),
                    IconButton(
                        onPressed: _datePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        //save button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      // if user open dropDown but didnt enter any value
                      if (value == null) {
                        return;
                      }
                      _selectedCategory = value;
                    });
                  }),
              //buttons
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: _submitNewExpense, child: const Text("Save")),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
