import '../models/claim.dart';
import '../models/reimbursement.dart';

abstract class ExpenseRepository {
  Future<List<MedicalClaim>> getMedicalClaims();
  Future<bool> submitMedicalClaim(MedicalClaim claim);
  Future<List<Reimbursement>> getReimbursements();
  Future<bool> submitReimbursement(Reimbursement reimbursement);
}
