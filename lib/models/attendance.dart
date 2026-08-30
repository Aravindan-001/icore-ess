enum AttendanceStatus {
  notMarked,
  checkedIn,
  checkedOut,
}

class AttendanceRecord {
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final AttendanceStatus status;

  AttendanceRecord({
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
  });

  AttendanceRecord copyWith({
    DateTime? checkInTime,
    DateTime? checkOutTime,
    AttendanceStatus? status,
  }) {
    return AttendanceRecord(
      date: date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      status: status ?? this.status,
    );
  }
}
