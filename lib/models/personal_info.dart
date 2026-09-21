import 'employment.dart';

class PersonalInformation {
  final PersonalDetails personalDetails;
  final EmployeeEmployment employmentDetails;
  final EmployeeContact contactInfo;

  PersonalInformation({
    required this.personalDetails,
    required this.employmentDetails,
    required this.contactInfo,
  });
}

class PersonalDetails {
  final String firstName;
  final String lastName;
  final String displayName;
  final String dateOfBirth;
  final String gender;
  final String placeOfBirth;
  final String nationality;
  final String motherTongue;
  final String bloodGroup;
  final String maritalStatus;
  final String residentialStatus;
  final String disability;

  PersonalDetails({
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.dateOfBirth,
    required this.gender,
    required this.placeOfBirth,
    required this.nationality,
    required this.motherTongue,
    required this.bloodGroup,
    required this.maritalStatus,
    required this.residentialStatus,
    required this.disability,
  });
}

class EmployeeContact {
  final String mobile;
  final String phone;
  final String officialEmail;
  final String personalEmail;

  EmployeeContact({
    required this.mobile,
    required this.phone,
    required this.officialEmail,
    required this.personalEmail,
  });
}
