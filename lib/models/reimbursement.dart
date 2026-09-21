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

  factory Reimbursement.fromJson(Map<String, dynamic> json) {
    return Reimbursement(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'category': category,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

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
