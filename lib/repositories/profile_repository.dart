import '../models/employee.dart';
import '../models/employment.dart';
import '../models/personal_info.dart';
import '../models/family.dart';
import '../models/bank.dart';
import '../models/education.dart';
import '../models/skill.dart';
import '../models/identity.dart';
import '../models/work_history.dart';
import '../models/certificate.dart';
import '../models/pending_request.dart';

abstract class ProfileRepository {
  Future<Employee> getEmployeeProfile();
  Future<EmployeeEmployment> getEmploymentSummary();
  Future<PersonalInformation> getPersonalInformation();
  Future<List<FamilyMember>> getFamilyInformation();
  Future<BankInformation> getBankInformation();
  Future<List<EducationRecord>> getEducationHistory();
  Future<List<EducationDocument>> getEducationDocuments();
  Future<List<Skill>> getSkills();
  Future<List<IdentityDocument>> getIdentityDocuments();
  Future<List<WorkExperience>> getWorkHistory();
  Future<List<Certificate>> getCertificates();
  Future<List<PendingRequest>> getProfileUpdateRequests();
}
