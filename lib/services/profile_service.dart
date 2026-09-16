import '../models/employee.dart';
import '../repositories/profile_repository.dart';

class ProfileService {
  final ProfileRepository _profileRepo;

  ProfileService(this._profileRepo);

  Future<Employee> getEmployeeProfile() => _profileRepo.getEmployeeProfile();
}
