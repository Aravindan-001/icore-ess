enum LeaveStatus { pending, approved, rejected }

class LeaveBalance {
  final String type;
  final double total;
  final double used;
  final double pending;

  LeaveBalance({
    required this.type,
    required this.total,
    required this.used,
    required this.pending,
  });

  double get available => total - used - pending;
}

class LeaveRequest {
  final String id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final DateTime appliedDate;

  LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.appliedDate,
  });
}
