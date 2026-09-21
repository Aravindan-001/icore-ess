enum EducationStatus {
  pending,
  approved,
  rejected,
}

class EducationDeclaration {
  final String id;
  final String employeeId;
  final String academicYear;
  final String institutionName;
  final String courseProgram;
  final String educationLevel;
  final String? academicPeriod;
  final double? amount;
  final EducationStatus status;
  final DateTime submittedDate;
  final String? approvedBy;
  final DateTime? approvalDate;
  final String? remarks;

  EducationDeclaration({
    required this.id,
    required this.employeeId,
    required this.academicYear,
    required this.institutionName,
    required this.courseProgram,
    required this.educationLevel,
    this.academicPeriod,
    this.amount,
    required this.status,
    required this.submittedDate,
    this.approvedBy,
    this.approvalDate,
    this.remarks,
  });

  String get statusText {
    switch (status) {
      case EducationStatus.pending:
        return 'Pending';
      case EducationStatus.approved:
        return 'Approved';
      case EducationStatus.rejected:
        return 'Rejected';
    }
  }
}
