enum AirfareStatus {
  pending,
  approved,
  rejected,
}

class AirfareDeclaration {
  final String id;
  final String employeeId;
  final String travelYear;
  final DateTime? travelDate;
  final String fromLocation;
  final String toLocation;
  final String travelType;
  final double? amount;
  final AirfareStatus status;
  final DateTime submittedDate;
  final String? approvedBy;
  final DateTime? approvalDate;
  final String? remarks;

  AirfareDeclaration({
    required this.id,
    required this.employeeId,
    required this.travelYear,
    this.travelDate,
    required this.fromLocation,
    required this.toLocation,
    required this.travelType,
    this.amount,
    required this.status,
    required this.submittedDate,
    this.approvedBy,
    this.approvalDate,
    this.remarks,
  });

  String get statusText {
    switch (status) {
      case AirfareStatus.pending:
        return 'Pending';
      case AirfareStatus.approved:
        return 'Approved';
      case AirfareStatus.rejected:
        return 'Rejected';
    }
  }
}
