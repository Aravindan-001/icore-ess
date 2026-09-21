import '../models/claim.dart';
import '../models/reimbursement.dart';
import '../models/reimbursement_models.dart';
import '../repositories/expense_repository.dart';
import '../repositories/profile_repository.dart';

class ExpenseService {
  final ExpenseRepository _expenseRepo;
  final ProfileRepository _profileRepo;

  ExpenseService(this._expenseRepo, this._profileRepo);

  Future<List<MedicalClaim>> getMedicalClaims() => _expenseRepo.getMedicalClaims();

  Future<List<Reimbursement>> getReimbursements() => _expenseRepo.getReimbursements();

  Future<List<ReimbursementRequest>> getReimbursementRequests() => _expenseRepo.getReimbursementRequests();

  Future<ReimbursementRequest?> getReimbursementRequestDetails(String docNum) => _expenseRepo.getReimbursementRequestDetails(docNum);

  Future<bool> saveReimbursementDraft(ReimbursementRequest request) {
    _validateRequest(request);
    return _expenseRepo.saveReimbursementDraft(request);
  }

  Future<bool> submitReimbursementRequest(ReimbursementRequest request) {
    _validateRequest(request);
    if (request.lineItems.isEmpty) {
      throw Exception('At least one line item is required before submission');
    }
    return _expenseRepo.submitReimbursementRequest(request);
  }

  Future<bool> cancelReimbursementRequest(String docNum) => _expenseRepo.cancelReimbursementRequest(docNum);

  void _validateRequest(ReimbursementRequest request) {
    for (var item in request.lineItems) {
      if (item.billAmount < 0 || item.claimAmount < 0) {
        throw Exception('Amounts cannot be negative');
      }
      if (item.claimAmount > item.billAmount) {
        throw Exception('Claim amount cannot exceed bill amount');
      }
      if (item.type.isEmpty || item.costCenter.isEmpty || item.description.isEmpty) {
        throw Exception('Required fields cannot be empty');
      }
    }
  }

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
