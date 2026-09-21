enum RequestModule {
  leave,
  overtime,
  airfare,
  education,
  profile,
  medicalClaim,
  reimbursement,
}

class UnifiedRequest {
  final String id;
  final String type;
  final DateTime submittedDate;
  final String status;
  final DateTime? lastUpdated;
  final String description;
  final RequestModule module;

  UnifiedRequest({
    required this.id,
    required this.type,
    required this.submittedDate,
    required this.status,
    this.lastUpdated,
    required this.description,
    required this.module,
  });
}
