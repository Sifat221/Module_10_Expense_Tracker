
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/expense.dart';
import 'package:expense_tracker/core/database_helper.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // Add Expense
  Future<void> addExpense() async {
    double? amount = double.tryParse(
      amountController.text.trim(),
    );

    if (titleController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    if (amount == null || amount <= 0) {
      showMessage('Amount must be greater than zero');
      return;
    }

    Expense expense = Expense(
      title: titleController.text.trim(),
      amount: amount,
    );

    await DatabaseHelper.insertExpense(expense);

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  // Save Button Pressed
  void saveButtonPressed() {
    addExpense();
  }

  // Show Message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Expense Title',
                hintText: 'Enter expense title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveButtonPressed,
                child: const Text('Save Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
