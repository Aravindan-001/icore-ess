import '../models/employee.dart';

abstract class ProfileRepository {
  Future<Employee> getEmployeeProfile();
}
