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
import '../repositories/profile_repository.dart';

class ProfileService {
  final ProfileRepository _profileRepo;

  ProfileService(this._profileRepo);

  Future<Employee> getEmployeeProfile() => _profileRepo.getEmployeeProfile();
  Future<EmployeeEmployment> getEmploymentSummary() => _profileRepo.getEmploymentSummary();
  Future<PersonalInformation> getPersonalInformation() => _profileRepo.getPersonalInformation();
  Future<List<FamilyMember>> getFamilyInformation() => _profileRepo.getFamilyInformation();
  Future<BankInformation> getBankInformation() => _profileRepo.getBankInformation();
  Future<List<EducationRecord>> getEducationHistory() => _profileRepo.getEducationHistory();
  Future<List<EducationDocument>> getEducationDocuments() => _profileRepo.getEducationDocuments();
  Future<List<Skill>> getSkills() => _profileRepo.getSkills();
  Future<List<IdentityDocument>> getIdentityDocuments() => _profileRepo.getIdentityDocuments();
  Future<List<WorkExperience>> getWorkHistory() => _profileRepo.getWorkHistory();
  Future<List<Certificate>> getCertificates() => _profileRepo.getCertificates();
  Future<List<PendingRequest>> getProfileUpdateRequests() => _profileRepo.getProfileUpdateRequests();
}
