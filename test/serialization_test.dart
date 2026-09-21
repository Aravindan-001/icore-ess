import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/models/employee.dart';
import 'package:icore_ess/models/attendance.dart';
import 'package:icore_ess/models/leave.dart';

void main() {
  group('Model Serialization Tests', () {
    test('Employee.fromJson handles standard JSON', () {
      final file = File('test/fixtures/employee_fixture.json');
      final jsonString = file.readAsStringSync();
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final employee = Employee.fromJson(jsonMap);

      expect(employee.id, 'EMP001');
      expect(employee.name, 'Aravind Kumar');
      expect(employee.email, 'aravind.kumar@ebaconnect.com');
    });

    test('AttendanceRecord serialization loop', () {
      final now = DateTime(2026, 9, 17, 10, 30);
      final record = AttendanceRecord(
        date: now,
        status: AttendanceStatus.checkedIn,
        checkInTime: now,
      );

      final jsonMap = record.toJson();
      final fromJson = AttendanceRecord.fromJson(jsonMap);

      expect(fromJson.date, record.date);
      expect(fromJson.status, record.status);
      expect(fromJson.checkInTime, record.checkInTime);
    });

    test('LeaveBalance serialization loop', () {
      final balance = LeaveBalance(
        type: 'Annual',
        total: 20,
        used: 5,
        pending: 2,
      );

      final jsonMap = balance.toJson();
      final fromJson = LeaveBalance.fromJson(jsonMap);

      expect(fromJson.type, balance.type);
      expect(fromJson.total, balance.total);
      expect(fromJson.available, balance.available);
    });
  });
}
