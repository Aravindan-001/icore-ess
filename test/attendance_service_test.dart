import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/core/errors/app_exceptions.dart';
import 'package:icore_ess/models/attendance.dart';
import 'package:icore_ess/models/employee.dart';
import 'package:icore_ess/repositories/attendance_repository.dart';
import 'package:icore_ess/repositories/profile_repository.dart';
import 'package:icore_ess/services/attendance_service.dart';
import 'package:icore_ess/services/location_service.dart';

class MockAttendanceRepo implements AttendanceRepository {
  AttendanceRecord record = AttendanceRecord(date: DateTime.now(), status: AttendanceStatus.notMarked);

  @override
  Future<AttendanceRecord> getTodayAttendance() async => record;

  @override
  Future<bool> checkIn(AttendanceRequest request) async {
    record = record.copyWith(status: AttendanceStatus.checkedIn);
    return true;
  }

  @override
  Future<bool> checkOut(AttendanceRequest request) async {
    record = record.copyWith(status: AttendanceStatus.checkedOut);
    return true;
  }
}

class MockProfileRepo implements ProfileRepository {
  @override
  Future<Employee> getEmployeeProfile() async => Employee(
    id: 'EMP001',
    name: 'Test',
    email: 'test@test.com',
    phone: '1234567890',
    designation: 'Dev',
    department: 'IT',
    joiningDate: '2020-01-01',
    profileImageUrl: '',
  );
}

class StaticLocationService implements LocationService {
  bool within = true;
  double accuracy = 10.0;

  @override
  Future<LocationResult> getLocationDetails() async => LocationResult(
    latitude: 0,
    longitude: 0,
    accuracy: accuracy,
    distanceFromOffice: within ? 10.0 : 1000.0,
    isWithinGeofence: within && accuracy <= 100.0,
  );

  @override
  Future<double> getDistanceFromOffice() async => 0;

  @override
  Future<bool> isWithinGeofence() async => within;
  
  @override
  Future<void> openLocationSettings() async {}
}

void main() {
  late AttendanceService service;
  late MockAttendanceRepo attendanceRepo;
  late StaticLocationService locationService;

  setUp(() {
    attendanceRepo = MockAttendanceRepo();
    locationService = StaticLocationService();
    service = AttendanceService(
      attendanceRepo,
      MockProfileRepo(),
      locationService,
    );
  });

  group('AttendanceService State Machine Tests', () {
    test('Valid Flow: NotMarked -> CheckedIn -> CheckedOut', () async {
      expect((await service.getTodayAttendance()).status, AttendanceStatus.notMarked);
      
      await service.checkIn();
      expect((await service.getTodayAttendance()).status, AttendanceStatus.checkedIn);
      
      await service.checkOut();
      expect((await service.getTodayAttendance()).status, AttendanceStatus.checkedOut);
    });

    test('Invalid: NotMarked -> CheckedOut', () async {
      expect((await service.getTodayAttendance()).status, AttendanceStatus.notMarked);
      
      expect(() => service.checkOut(), throwsA(isA<ValidationException>()));
    });

    test('Invalid: CheckedIn -> CheckedIn', () async {
      await service.checkIn();
      expect((await service.getTodayAttendance()).status, AttendanceStatus.checkedIn);
      
      expect(() => service.checkIn(), throwsA(isA<ValidationException>()));
    });

    test('Invalid: CheckedOut -> CheckedIn', () async {
      await service.checkIn();
      await service.checkOut();
      expect((await service.getTodayAttendance()).status, AttendanceStatus.checkedOut);
      
      expect(() => service.checkIn(), throwsA(isA<ValidationException>()));
    });

    test('Invalid: CheckedOut -> CheckedOut', () async {
      await service.checkIn();
      await service.checkOut();
      expect((await service.getTodayAttendance()).status, AttendanceStatus.checkedOut);
      
      expect(() => service.checkOut(), throwsA(isA<ValidationException>()));
    });

    test('Geofence: Block CheckIn when outside', () async {
      locationService.within = false;
      expect(() => service.checkIn(), throwsA(isA<LocationException>()));
    });

    test('Accuracy: Block CheckIn when accuracy is poor', () async {
      locationService.accuracy = 500.0;
      expect(() => service.checkIn(), throwsA(isA<LocationException>()));
    });
  });
}
