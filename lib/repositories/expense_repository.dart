import '../models/claim.dart';
import '../models/reimbursement.dart';
import '../models/reimbursement_models.dart';

abstract class ExpenseRepository {
  Future<List<MedicalClaim>> getMedicalClaims();
  Future<bool> submitMedicalClaim(MedicalClaim claim);
  Future<List<Reimbursement>> getReimbursements();
  Future<bool> submitReimbursement(Reimbursement reimbursement);

  // Modern rich reimbursement contract operations
  Future<List<ReimbursementRequest>> getReimbursementRequests();
  Future<ReimbursementRequest?> getReimbursementRequestDetails(String documentNumber);
  Future<bool> saveReimbursementDraft(ReimbursementRequest request);
  Future<bool> submitReimbursementRequest(ReimbursementRequest request);
  Future<bool> cancelReimbursementRequest(String documentNumber);
}
