enum OvertimeStatus {
  pending,
  approved,
  rejected,
}

class OvertimeRequest {
  final String id;
  final DateTime date;
  final double hours;
  final String reason;
  final OvertimeStatus status;
  final DateTime submittedDate;
  final String? approvedBy;
  final DateTime? approvalDate;
  final String? remarks;

  OvertimeRequest({
    required this.id,
    required this.date,
    required this.hours,
    required this.reason,
    required this.status,
    required this.submittedDate,
    this.approvedBy,
    this.approvalDate,
    this.remarks,
  });

  factory OvertimeRequest.fromJson(Map<String, dynamic> json) {
    return OvertimeRequest(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      hours: (json['hours'] ?? 0).toDouble(),
      reason: json['reason'] ?? '',
      status: OvertimeStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OvertimeStatus.pending,
      ),
      submittedDate: DateTime.parse(json['submittedDate']),
      approvedBy: json['approvedBy'],
      approvalDate: json['approvalDate'] != null ? DateTime.parse(json['approvalDate']) : null,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'hours': hours,
      'reason': reason,
      'status': status.toString().split('.').last,
      'submittedDate': submittedDate.toIso8601String(),
      'approvedBy': approvedBy,
      'approvalDate': approvalDate?.toIso8601String(),
      'remarks': remarks,
    };
  }

  String get statusText {
    switch (status) {
      case OvertimeStatus.pending:
        return 'Pending';
      case OvertimeStatus.approved:
        return 'Approved';
      case OvertimeStatus.rejected:
        return 'Rejected';
    }
  }
}
