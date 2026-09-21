import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/attendance.dart';
import '../../services/location_service.dart';

/// Provider for today's attendance record
final todayAttendanceProvider = FutureProvider<AttendanceRecord>((ref) async {
  final service = ref.watch(attendanceServiceProvider);
  return service.getTodayAttendance();
});

/// Provider for current location details
final attendanceLocationProvider = FutureProvider<LocationResult>((ref) async {
  final service = ref.watch(attendanceServiceProvider);
  return service.getCurrentLocation();
});

/// Provider for attendance history list
final attendanceHistoryProvider = FutureProvider<List<AttendanceRecord>>((ref) async {
  final service = ref.watch(attendanceServiceProvider);
  return service.getAttendanceHistory();
});

class AttendanceActionState {
  final bool isProcessing;
  final String? error;
  final String? successMessage;

  AttendanceActionState({
    required this.isProcessing,
    this.error,
    this.successMessage,
  });

  factory AttendanceActionState.initial() => AttendanceActionState(isProcessing: false);
  factory AttendanceActionState.loading() => AttendanceActionState(isProcessing: true);
  factory AttendanceActionState.success(String message) => AttendanceActionState(isProcessing: false, successMessage: message);
  factory AttendanceActionState.error(String message) => AttendanceActionState(isProcessing: false, error: message);
}

class AttendanceActionNotifier extends StateNotifier<AttendanceActionState> {
  final Ref _ref;

  AttendanceActionNotifier(this._ref) : super(AttendanceActionState.initial());

  Future<void> checkIn() async {
    state = AttendanceActionState.loading();
    try {
      final service = _ref.read(attendanceServiceProvider);
      final success = await service.checkIn();
      if (success) {
        state = AttendanceActionState.success('Checked in successfully!');
        _ref.invalidate(todayAttendanceProvider);
        _ref.invalidate(attendanceLocationProvider);
        _ref.invalidate(attendanceHistoryProvider);
      } else {
        state = AttendanceActionState.error('Failed to check in.');
      }
    } catch (e) {
      state = AttendanceActionState.error(_parseError(e));
    }
  }

  Future<void> checkOut() async {
    state = AttendanceActionState.loading();
    try {
      final service = _ref.read(attendanceServiceProvider);
      final success = await service.checkOut();
      if (success) {
        state = AttendanceActionState.success('Checked out successfully!');
        _ref.invalidate(todayAttendanceProvider);
        _ref.invalidate(attendanceLocationProvider);
        _ref.invalidate(attendanceHistoryProvider);
      } else {
        state = AttendanceActionState.error('Failed to check out.');
      }
    } catch (e) {
      state = AttendanceActionState.error(_parseError(e));
    }
  }

  void clearStatus() {
    state = AttendanceActionState.initial();
  }

  String _parseError(Object e) {
    String message = e.toString();
    if (message.startsWith('Exception: ')) {
      message = message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}

final attendanceActionProvider = StateNotifierProvider<AttendanceActionNotifier, AttendanceActionState>((ref) {
  return AttendanceActionNotifier(ref);
});
