import '../models/leave.dart';

abstract class LeaveRepository {
  Future<List<LeaveBalance>> getLeaveBalances();
  Future<List<LeaveRequest>> getLeaveRequests();
  Future<bool> applyLeave(LeaveRequest request);
}
