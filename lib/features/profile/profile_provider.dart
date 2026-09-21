import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/employee.dart';
import '../../models/personal_info.dart';
import '../../models/family.dart';
import '../../models/bank.dart';
import '../../models/education.dart';
import '../../models/skill.dart';
import '../../models/identity.dart';
import '../../models/work_history.dart';
import '../../models/certificate.dart';
import '../../models/pending_request.dart';

final employeeProfileProvider = FutureProvider<Employee>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getEmployeeProfile();
});

final personalInfoProvider = FutureProvider<PersonalInformation>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getPersonalInformation();
});

final familyInfoProvider = FutureProvider<List<FamilyMember>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getFamilyInformation();
});

final bankInfoProvider = FutureProvider<BankInformation>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getBankInformation();
});

final educationHistoryProvider = FutureProvider<List<EducationRecord>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getEducationHistory();
});

final educationDocumentsProvider = FutureProvider<List<EducationDocument>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getEducationDocuments();
});

final skillsProvider = FutureProvider<List<Skill>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getSkills();
});

final identityDocumentsProvider = FutureProvider<List<IdentityDocument>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getIdentityDocuments();
});

final workHistoryProvider = FutureProvider<List<WorkExperience>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getWorkHistory();
});

final certificatesProvider = FutureProvider<List<Certificate>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getCertificates();
});

final profileRequestsProvider = FutureProvider<List<PendingRequest>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getProfileUpdateRequests();
});
