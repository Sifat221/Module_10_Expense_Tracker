
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/expense.dart';
import 'package:expense_tracker/core/database_helper.dart';
import 'package:expense_tracker/presentation/add_expense/add_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    List<Expense> expenseFromDatabase =
    await DatabaseHelper.getExpenses();

    if (!mounted) return;

    setState(() {
      _expenses.clear();
      _expenses.addAll(expenseFromDatabase);
    });
  }

  double get _totalExpenses {
    double total = 0;

    for (Expense expense in _expenses) {
      total = total + expense.amount;
    }

    return total;
  }

  Future<void> _goToAddExpense() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddExpensePage(),
      ),
    );

    _loadExpenses();
  }

  Future<void> _deleteExpense(int id) async {
    await DatabaseHelper.deleteExpense(id);

    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Expenses',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '৳${_totalExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'All Expenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: _expenses.isEmpty
                  ? const Center(
                child: Text(
                  'No expenses found',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  Expense expense = _expenses[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        expense.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        'Amount: ৳${expense.amount.toStringAsFixed(2)}',
                      ),

                      trailing: IconButton(
                        onPressed: () {
                          _deleteExpense(expense.id!);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddExpense,
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
