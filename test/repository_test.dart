import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/repositories/mock_ess_repository.dart';
import 'package:icore_ess/models/leave.dart';
import 'package:icore_ess/models/attendance.dart';

void main() {
  group('MockEssRepository Tests', () {
    final repository = MockEssRepository();

    test('login with correct credentials returns true', () async {
      final result = await repository.login('EMP001', '123456');
      expect(result, true);
    });

    test('login with incorrect credentials returns false', () async {
      final result = await repository.login('WRONG', 'wrong');
      expect(result, false);
    });

    test('getEmployeeProfile returns mock data', () async {
      final employee = await repository.getEmployeeProfile();
      expect(employee.name, 'Aravind Kumar');
      expect(employee.id, 'EMP001');
    });

    test('getLeaveBalances returns list', () async {
      final balances = await repository.getLeaveBalances();
      expect(balances.length, greaterThan(0));
      expect(balances.first.type, 'Annual Leave');
    });

    test('getLeaveRequests returns list', () async {
      final requests = await repository.getLeaveRequests();
      expect(requests.length, greaterThan(0));
    });

    test('getPayslips returns list', () async {
      final payslips = await repository.getPayslips();
      expect(payslips.length, greaterThan(0));
      expect(payslips.first.month, 'January');
    });

    test('Attendance sequential rules', () async {
      final now = DateTime.now();
      
      // Initial state
      final initial = await repository.getTodayAttendance();
      expect(initial.status, AttendanceStatus.notMarked);
      
      // Cannot check out if not marked
      final checkOutFail = await repository.checkOut(now);
      expect(checkOutFail, isFalse);
      
      // Check in
      final checkInSuccess = await repository.checkIn(now);
      expect(checkInSuccess, isTrue);
      
      final afterIn = await repository.getTodayAttendance();
      expect(afterIn.status, AttendanceStatus.checkedIn);
      expect(afterIn.checkInTime, now);
      
      // Cannot check in again
      final checkInFail = await repository.checkIn(now);
      expect(checkInFail, isFalse);
      
      // Check out
      final checkOutSuccess = await repository.checkOut(now);
      expect(checkOutSuccess, isTrue);
      
      final afterOut = await repository.getTodayAttendance();
      expect(afterOut.status, AttendanceStatus.checkedOut);
      expect(afterOut.checkOutTime, now);
      
      // Cannot check out again
      final checkOutFail2 = await repository.checkOut(now);
      expect(checkOutFail2, isFalse);
      
      // Cannot check in after completion
      final checkInFail2 = await repository.checkIn(now);
      expect(checkInFail2, isFalse);
    });

    test('applyLeave returns true', () async {
      final result = await repository.applyLeave(LeaveRequest(
        id: 'test',
        type: 'Annual Leave',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        reason: 'test',
        status: LeaveStatus.pending,
        appliedDate: DateTime.now(),
      ));
      expect(result, true);
    });
  });
}
