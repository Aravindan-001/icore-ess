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

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: DateTime.parse(json['date']),
      checkInTime: json['checkInTime'] != null ? DateTime.parse(json['checkInTime']) : null,
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AttendanceStatus.notMarked,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

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

class AttendanceRequest {
  final String employeeId;
  final String action; // 'CHECK_IN' or 'CHECK_OUT'
  final DateTime deviceTime;
  final double latitude;
  final double longitude;
  final double accuracy;
  final bool isMocked;
  final String appVersion;

  AttendanceRequest({
    required this.employeeId,
    required this.action,
    required this.deviceTime,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.isMocked,
    required this.appVersion,
  });

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'action': action,
      'deviceTime': deviceTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'isMocked': isMocked,
      'appVersion': appVersion,
    };
  }
}
