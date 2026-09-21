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

  factory MedicalClaim.fromJson(Map<String, dynamic> json) {
    return MedicalClaim(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      type: json['type'] ?? '',
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
      'type': type,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

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
