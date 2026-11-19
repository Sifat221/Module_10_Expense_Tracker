
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/core/expense.dart';

class DatabaseHelper {
  // Open Database
  static Future<Database> getDatabase() async {
    String folder = await getDatabasesPath();
    String path = join(folder, 'expense_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL
          )
        ''');
      },
    );
  }

  // Add Expense
  static Future<void> insertExpense(Expense expense) async {
    final db = await getDatabase();

    await db.insert(
      'expenses',
      expense.toMap(),
    );
  }

  // Get All Expenses
  static Future<List<Expense>> getExpenses() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> rows = await db.query(
      'expenses',
      orderBy: 'id DESC',
    );

    List<Expense> expenses = [];

    for (Map<String, dynamic> row in rows) {
      expenses.add(Expense.fromMap(row));
    }

    return expenses;
  }

  // Delete Expense
  static Future<void> deleteExpense(int id) async {
    final db = await getDatabase();

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
