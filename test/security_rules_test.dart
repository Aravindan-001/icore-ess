import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/models/attendance.dart';
import 'package:icore_ess/repositories/mock_ess_repository.dart';

void main() {
  group('Security and Business Rule Tests', () {
    final repository = MockEssRepository();

    test('AttendanceRequest captures security metadata', () {
      final now = DateTime.now();
      final request = AttendanceRequest(
        employeeId: 'EMP001',
        action: 'CHECK_IN',
        deviceTime: now,
        latitude: 13.0827,
        longitude: 80.2707,
        accuracy: 10.5,
        isMocked: true, // Spoofed location
        appVersion: '1.0.0',
      );

      expect(request.employeeId, 'EMP001');
      expect(request.isMocked, true);
      expect(request.accuracy, 10.5);
      
      final json = request.toJson();
      expect(json['isMocked'], true);
      expect(json['latitude'], 13.0827);
    });

    test('Repository enforces sequential attendance even with mock requests', () async {
      final now = DateTime.now();
      final checkInRequest = AttendanceRequest(
        employeeId: 'EMP001',
        action: 'CHECK_IN',
        deviceTime: now,
        latitude: 13.0827,
        longitude: 80.2707,
        accuracy: 5.0,
        isMocked: false,
        appVersion: '1.0.0',
      );

      // 1. Success Check-In
      bool result = await repository.checkIn(checkInRequest);
      expect(result, true);

      // 2. Prevent Duplicate Check-In
      result = await repository.checkIn(checkInRequest);
      expect(result, false);

      // 3. Prevent Check-Out with wrong action (though repository checkOut method is used)
      final checkOutRequest = AttendanceRequest(
        employeeId: 'EMP001',
        action: 'CHECK_OUT',
        deviceTime: now.add(const Duration(hours: 8)),
        latitude: 13.0827,
        longitude: 80.2707,
        accuracy: 5.0,
        isMocked: false,
        appVersion: '1.0.0',
      );

      result = await repository.checkOut(checkOutRequest);
      expect(result, true);

      // 4. Prevent further actions after completion
      result = await repository.checkOut(checkOutRequest);
      expect(result, false);
      
      result = await repository.checkIn(checkInRequest);
      expect(result, false);
    });
  });
}
