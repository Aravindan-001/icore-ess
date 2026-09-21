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

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      type: json['type'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      used: (json['used'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'total': total,
      'used': used,
      'pending': pending,
    };
  }

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

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'] ?? '',
      status: LeaveStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => LeaveStatus.pending,
      ),
      appliedDate: DateTime.parse(json['appliedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      'status': status.toString().split('.').last,
      'appliedDate': appliedDate.toIso8601String(),
    };
  }
}
