import '../models/claim.dart';
import '../models/reimbursement.dart';
import '../repositories/expense_repository.dart';
import '../repositories/profile_repository.dart';

class ExpenseService {
  final ExpenseRepository _expenseRepo;
  final ProfileRepository _profileRepo;

  ExpenseService(this._expenseRepo, this._profileRepo);

  Future<List<MedicalClaim>> getMedicalClaims() => _expenseRepo.getMedicalClaims();

  Future<List<Reimbursement>> getReimbursements() => _expenseRepo.getReimbursements();

  Future<bool> submitMedicalClaim({
    required String type,
    required String description,
    required double amount,
  }) async {
    final employee = await _profileRepo.getEmployeeProfile();
    final claim = MedicalClaim(
      id: 'CLM${DateTime.now().millisecondsSinceEpoch}',
      employeeId: employee.id,
      type: type,
      description: description,
      amount: amount,
      date: DateTime.now(),
      status: 'Pending',
    );
    return _expenseRepo.submitMedicalClaim(claim);
  }

  Future<bool> submitReimbursement({
    required String category,
    required String description,
    required double amount,
  }) async {
    final employee = await _profileRepo.getEmployeeProfile();
    final reimbursement = Reimbursement(
      id: 'REI${DateTime.now().millisecondsSinceEpoch}',
      employeeId: employee.id,
      category: category,
      description: description,
      amount: amount,
      date: DateTime.now(),
      status: 'Pending',
    );
    return _expenseRepo.submitReimbursement(reimbursement);
  }
}
