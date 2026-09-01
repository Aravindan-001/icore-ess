class Reimbursement {
  final String id;
  final String employeeId;
  final String category;
  final String description;
  final double amount;
  final DateTime date;
  final String status; // Pending, Approved, Rejected

  Reimbursement({
    required this.id,
    required this.employeeId,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });

  Reimbursement copyWith({
    String? status,
  }) {
    return Reimbursement(
      id: id,
      employeeId: employeeId,
      category: category,
      description: description,
      amount: amount,
      date: date,
      status: status ?? this.status,
    );
  }
}
