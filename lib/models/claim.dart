class MedicalClaim {
  final String id;
  final String employeeId;
  final String type;
  final String description;
  final double amount;
  final DateTime date;
  final String status; // Pending, Approved, Rejected

  MedicalClaim({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });

  MedicalClaim copyWith({
    String? status,
  }) {
    return MedicalClaim(
      id: id,
      employeeId: employeeId,
      type: type,
      description: description,
      amount: amount,
      date: date,
      status: status ?? this.status,
    );
  }
}
