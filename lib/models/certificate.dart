class Certificate {
  final String name;
  final String issuingOrganization;
  final String issueDate;
  final String? expiryDate;
  final String? documentUrl;

  Certificate({
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    this.expiryDate,
    this.documentUrl,
  });
}
