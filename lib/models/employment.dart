class EmployeeEmployment {
  final String employeeId;
  final String legacyId;
  final String joiningDate;
  final String grade;
  final String employmentType;
  final String pointOfHire;
  final String department;
  final String designation;
  final String location;
  final String yearsOfService;

  EmployeeEmployment({
    required this.employeeId,
    required this.legacyId,
    required this.joiningDate,
    required this.grade,
    required this.employmentType,
    required this.pointOfHire,
    required this.department,
    required this.designation,
    required this.location,
    required this.yearsOfService,
  });

  factory EmployeeEmployment.fromJson(Map<String, dynamic> json) {
    return EmployeeEmployment(
      employeeId: json['employeeId'] ?? '',
      legacyId: json['legacyId'] ?? '',
      joiningDate: json['joiningDate'] ?? '',
      grade: json['grade'] ?? '',
      employmentType: json['employmentType'] ?? '',
      pointOfHire: json['pointOfHire'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      location: json['location'] ?? '',
      yearsOfService: json['yearsOfService'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'legacyId': legacyId,
      'joiningDate': joiningDate,
      'grade': grade,
      'employmentType': employmentType,
      'pointOfHire': pointOfHire,
      'department': department,
      'designation': designation,
      'location': location,
      'yearsOfService': yearsOfService,
    };
  }
}
