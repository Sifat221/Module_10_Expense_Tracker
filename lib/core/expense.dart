
class Expense {
  Expense({
    this.id,
    required this.title,
    required this.amount,
  });

  final int? id;
  final String title;
  final double amount;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> mp) {
    return Expense(
      id: mp['id'] as int?,
      title: mp['title'],
      amount: (mp['amount'] as num).toDouble(),
    );
  }
}
