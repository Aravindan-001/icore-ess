import '../models/leave.dart';
import '../repositories/leave_repository.dart';

class LeaveService {
  final LeaveRepository _leaveRepo;

  LeaveService(this._leaveRepo);

  Future<List<LeaveBalance>> getLeaveBalances() => _leaveRepo.getLeaveBalances();

  Future<List<LeaveRequest>> getLeaveRequests() => _leaveRepo.getLeaveRequests();

  Future<bool> applyLeave({
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    final request = LeaveRequest(
      id: 'LR${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      status: LeaveStatus.pending,
      appliedDate: DateTime.now(),
    );
    return _leaveRepo.applyLeave(request);
  }
}
