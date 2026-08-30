import '../models/employee.dart';
import '../models/leave.dart';
import '../models/payslip.dart';
import '../models/attendance.dart';
import '../services/mock/mock_data_service.dart';
import 'ess_repository.dart';

class MockEssRepository implements EssRepository {
  AttendanceRecord _todayAttendance = AttendanceRecord(
    date: DateTime.now(),
    status: AttendanceStatus.notMarked,
  );

  @override
  Future<bool> login(String employeeId, String password) async {
    // DEVELOPMENT MOCK ONLY: Real authentication will use SOAP/XML services.
    // Integration point for Session Security: Store returned AuthToken/SessionID in flutter_secure_storage.
    await Future.delayed(const Duration(seconds: 1));
    return employeeId == 'EMP001' && password == '123456';
  }

  @override
  Future<Employee> getEmployeeProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.mockEmployee;
  }

  @override
  Future<List<LeaveBalance>> getLeaveBalances() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.mockLeaveBalances;
  }

  @override
  Future<List<LeaveRequest>> getLeaveRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.mockLeaveRequests;
  }

  @override
  Future<List<Payslip>> getPayslips() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.mockPayslips;
  }

  @override
  Future<bool> applyLeave(LeaveRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<AttendanceRecord> getTodayAttendance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _todayAttendance;
  }

  @override
  Future<bool> checkIn(DateTime time) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_todayAttendance.status != AttendanceStatus.notMarked) return false;
    
    _todayAttendance = _todayAttendance.copyWith(
      checkInTime: time,
      status: AttendanceStatus.checkedIn,
    );
    return true;
  }

  @override
  Future<bool> checkOut(DateTime time) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_todayAttendance.status != AttendanceStatus.checkedIn) return false;
    
    _todayAttendance = _todayAttendance.copyWith(
      checkOutTime: time,
      status: AttendanceStatus.checkedOut,
    );
    return true;
  }
}
