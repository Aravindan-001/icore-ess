class WorkExperience {
  final String company;
  final String designation;
  final String fromDate;
  final String toDate;
  final String location;
  final bool isCurrent;

  WorkExperience({
    required this.company,
    required this.designation,
    required this.fromDate,
    required this.toDate,
    required this.location,
    this.isCurrent = false,
  });
}
