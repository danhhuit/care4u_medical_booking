class TransactionEntity {
  final String id;
  final String title;
  final int amount;
  final String type;
  final String status;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
  });
}