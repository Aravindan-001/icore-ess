class EducationRecord {
  final String degree;
  final String institution;
  final String specialization;
  final String startYear;
  final String endYear;
  final String? grade;

  EducationRecord({
    required this.degree,
    required this.institution,
    required this.specialization,
    required this.startYear,
    required this.endYear,
    this.grade,
  });
}

class EducationDocument {
  final String name;
  final String educationLevel;
  final DateTime uploadDate;
  final String fileType;
  final String? fileUrl;

  EducationDocument({
    required this.name,
    required this.educationLevel,
    required this.uploadDate,
    required this.fileType,
    this.fileUrl,
  });
}
