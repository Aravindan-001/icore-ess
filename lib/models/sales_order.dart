class SalesOrder {
  final String orderNumber;
  final DateTime date;
  final double amount;
  final String status;

  SalesOrder({
    required this.orderNumber,
    required this.date,
    required this.amount,
    required this.status,
  });
}
