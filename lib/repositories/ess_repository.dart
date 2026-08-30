import '../models/employee.dart';
import '../models/leave.dart';
import '../models/payslip.dart';
import '../models/attendance.dart';

abstract class EssRepository {
  Future<bool> login(String employeeId, String password);
  Future<Employee> getEmployeeProfile();
  Future<List<LeaveBalance>> getLeaveBalances();
  Future<List<LeaveRequest>> getLeaveRequests();
  Future<List<Payslip>> getPayslips();
  Future<bool> applyLeave(LeaveRequest request);
  
  // Attendance methods
  Future<AttendanceRecord> getTodayAttendance();
  Future<bool> checkIn(DateTime time);
  Future<bool> checkOut(DateTime time);
}
