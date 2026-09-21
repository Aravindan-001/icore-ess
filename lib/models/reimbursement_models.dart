

enum ReimbursementStatus {
  newStatus,
  submitted,
  approved,
  rejected,
  cancelled,
  paid;

  String get displayName {
    switch (this) {
      case ReimbursementStatus.newStatus:
        return 'New';
      case ReimbursementStatus.submitted:
        return 'Submitted';
      case ReimbursementStatus.approved:
        return 'Approved';
      case ReimbursementStatus.rejected:
        return 'Rejected';
      case ReimbursementStatus.cancelled:
        return 'Cancelled';
      case ReimbursementStatus.paid:
        return 'Paid';
    }
  }
}

enum DocumentType {
  general,
  travel,
  medical,
  education,
  fuel,
  other;

  String get displayName {
    switch (this) {
      case DocumentType.general:
        return 'General';
      case DocumentType.travel:
        return 'Travel';
      case DocumentType.medical:
        return 'Medical';
      case DocumentType.education:
        return 'Education';
      case DocumentType.fuel:
        return 'Fuel';
      case DocumentType.other:
        return 'Other';
    }
  }
}

enum AttachmentStatus {
  none,
  selected,
  uploaded,
  failed
}

class CostCenter {
  final String id;
  final String name;

  const CostCenter({required this.id, required this.name});
}

class ReimbursementAttachment {
  final String fileName;
  final String? filePath;
  final AttachmentStatus status;

  const ReimbursementAttachment({
    required this.fileName,
    this.filePath,
    required this.status,
  });
}

class ReimbursementLineItem {
  final String id;
  final String type;
  final String costCenter;
  final String description;
  final String billRefNo;
  final DateTime date;
  final double billAmount;
  final double claimAmount;
  final ReimbursementAttachment? attachment;

  ReimbursementLineItem({
    required this.id,
    required this.type,
    required this.costCenter,
    required this.description,
    required this.billRefNo,
    required this.date,
    required this.billAmount,
    required this.claimAmount,
    this.attachment,
  });

  ReimbursementLineItem copyWith({
    String? type,
    String? costCenter,
    String? description,
    String? billRefNo,
    DateTime? date,
    double? billAmount,
    double? claimAmount,
    ReimbursementAttachment? attachment,
  }) {
    return ReimbursementLineItem(
      id: id,
      type: type ?? this.type,
      costCenter: costCenter ?? this.costCenter,
      description: description ?? this.description,
      billRefNo: billRefNo ?? this.billRefNo,
      date: date ?? this.date,
      billAmount: billAmount ?? this.billAmount,
      claimAmount: claimAmount ?? this.claimAmount,
      attachment: attachment ?? this.attachment,
    );
  }
}

class ReimbursementRequest {
  final String documentNumber;
  final DateTime date;
  final DocumentType documentType;
  final ReimbursementStatus status;
  final List<ReimbursementLineItem> lineItems;
  final String notes;
  final double totalBillAmount;
  final double totalClaimAmount;
  final double totalReimbursedAmount;

  ReimbursementRequest({
    required this.documentNumber,
    required this.date,
    required this.documentType,
    required this.status,
    required this.lineItems,
    required this.notes,
    required this.totalBillAmount,
    required this.totalClaimAmount,
    required this.totalReimbursedAmount,
  });

  bool get isEditable =>
      status == ReimbursementStatus.newStatus || status == ReimbursementStatus.cancelled;

  ReimbursementRequest copyWith({
    DateTime? date,
    DocumentType? documentType,
    ReimbursementStatus? status,
    List<ReimbursementLineItem>? lineItems,
    String? notes,
    double? totalBillAmount,
    double? totalClaimAmount,
    double? totalReimbursedAmount,
  }) {
    return ReimbursementRequest(
      documentNumber: documentNumber,
      date: date ?? this.date,
      documentType: documentType ?? this.documentType,
      status: status ?? this.status,
      lineItems: lineItems ?? this.lineItems,
      notes: notes ?? this.notes,
      totalBillAmount: totalBillAmount ?? this.totalBillAmount,
      totalClaimAmount: totalClaimAmount ?? this.totalClaimAmount,
      totalReimbursedAmount: totalReimbursedAmount ?? this.totalReimbursedAmount,
    );
  }
}
