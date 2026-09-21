import '../models/attendance.dart';

abstract class AttendanceRepository {
  Future<AttendanceRecord> getTodayAttendance();
  Future<bool> checkIn(AttendanceRequest request);
  Future<bool> checkOut(AttendanceRequest request);
  Future<List<AttendanceRecord>> getAttendanceHistory();
}
