class RecentTransactionModel {
  final int amount;
  final String category;
  final String dateTime;
  final DateTime sampledate;
  final String notes;
  final String paymentMethod;
  final String type;

  RecentTransactionModel({
    required this.amount,
    required this.category,
    required this.dateTime,
    required this.notes,
    required this.paymentMethod,
    required this.type,
    required this.sampledate,
  });
}
