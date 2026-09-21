class IdentityDocument {
  final String type;
  final String documentNumber;
  final String issueDate;
  final String? expiryDate;
  final String status;

  IdentityDocument({
    required this.type,
    required this.documentNumber,
    required this.issueDate,
    this.expiryDate,
    required this.status,
  });

  String get maskedNumber {
    if (documentNumber.length < 4) return documentNumber;
    final lastFour = documentNumber.substring(documentNumber.length - 4);
    return '**** **** $lastFour';
  }
}
