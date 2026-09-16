import '../core/constants/app_constants.dart';
import '../core/errors/app_exceptions.dart';
import '../models/attendance.dart';
import '../repositories/attendance_repository.dart';
import '../repositories/profile_repository.dart';
import 'location_service.dart';

class AttendanceState {
  final AttendanceRecord? record;
  final LocationResult? location;
  final bool isLoading;
  final String? error;

  AttendanceState({
    this.record,
    this.location,
    this.isLoading = false,
    this.error,
  });

  bool get canCheckIn => 
      record?.status == AttendanceStatus.notMarked && 
      (location?.isWithinGeofence ?? false);

  bool get canCheckOut => 
      record?.status == AttendanceStatus.checkedIn && 
      (location?.isWithinGeofence ?? false);
}

class AttendanceService {
  final AttendanceRepository _attendanceRepo;
  final ProfileRepository _profileRepo;
  final LocationService _locationService;

  AttendanceService(
    this._attendanceRepo,
    this._profileRepo,
    this._locationService,
  );

  Future<AttendanceRecord> getTodayAttendance() => _attendanceRepo.getTodayAttendance();

  Future<LocationResult> getCurrentLocation() => _locationService.getLocationDetails();

  Future<bool> checkIn() async {
    final location = await _locationService.getLocationDetails();
    if (!location.isWithinGeofence) {
      if (location.accuracy > AppConstants.maxAllowedAccuracyInMeters) {
        throw LocationException('GPS accuracy is too low (${location.accuracy.toStringAsFixed(1)}m). Please move to an open area.');
      }
      throw LocationException('You must be within 50 meters of the office to check in.');
    }

    final attendance = await _attendanceRepo.getTodayAttendance();
    if (attendance.status != AttendanceStatus.notMarked) {
      throw ValidationException('Invalid attendance state for check-in: ${attendance.status}');
    }

    final employee = await _profileRepo.getEmployeeProfile();
    final request = AttendanceRequest(
      employeeId: employee.id,
      action: 'CHECK_IN',
      deviceTime: DateTime.now(),
      latitude: location.latitude,
      longitude: location.longitude,
      accuracy: location.accuracy,
      isMocked: location.isMocked,
      appVersion: AppConstants.appVersion,
    );

    return await _attendanceRepo.checkIn(request);
  }

  Future<bool> checkOut() async {
    final location = await _locationService.getLocationDetails();
    if (!location.isWithinGeofence) {
      if (location.accuracy > AppConstants.maxAllowedAccuracyInMeters) {
        throw LocationException('GPS accuracy is too low (${location.accuracy.toStringAsFixed(1)}m). Please move to an open area.');
      }
      throw LocationException('You must return to the office area to check out.');
    }

    final attendance = await _attendanceRepo.getTodayAttendance();
    if (attendance.status != AttendanceStatus.checkedIn) {
      throw ValidationException('Invalid attendance state for check-out: ${attendance.status}');
    }

    final employee = await _profileRepo.getEmployeeProfile();
    final request = AttendanceRequest(
      employeeId: employee.id,
      action: 'CHECK_OUT',
      deviceTime: DateTime.now(),
      latitude: location.latitude,
      longitude: location.longitude,
      accuracy: location.accuracy,
      isMocked: location.isMocked,
      appVersion: AppConstants.appVersion,
    );

    return await _attendanceRepo.checkOut(request);
  }
}
