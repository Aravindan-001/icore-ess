class PendingRequest {
  final String id;
  final String type;
  final DateTime submittedDate;
  final String status;
  final DateTime lastUpdated;
  final String description;

  PendingRequest({
    required this.id,
    required this.type,
    required this.submittedDate,
    required this.status,
    required this.lastUpdated,
    required this.description,
  });
}
