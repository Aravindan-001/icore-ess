import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/core/constants/app_constants.dart';
import 'package:icore_ess/services/location_service.dart';

void main() {
  group('Geofence Logic Tests', () {
    final locationService = MockLocationService();

    test('Distance calculation is accurate', () {
      // Test same point
      double distance = locationService.calculateDistance(
        AppConstants.officeLatitude,
        AppConstants.officeLongitude,
        AppConstants.officeLatitude,
        AppConstants.officeLongitude,
      );
      expect(distance, closeTo(0.0, 0.1));

      // Test small offset (~11m)
      // 0.0001 degrees is roughly 11 meters
      distance = locationService.calculateDistance(
        AppConstants.officeLatitude,
        AppConstants.officeLongitude,
        AppConstants.officeLatitude + 0.0001,
        AppConstants.officeLongitude,
      );
      expect(distance, greaterThan(10.0));
      expect(distance, lessThan(12.0));
    });

    test('Boundary 50m check', () {
      // Exactly at office
      locationService.setMockLocation(AppConstants.officeLatitude, AppConstants.officeLongitude);
      expect(locationService.isWithinGeofence(), completion(isTrue));

      // Slightly inside 50m
      // 0.0004 degrees latitude is ~44.4 meters
      locationService.setMockLocation(AppConstants.officeLatitude + 0.0004, AppConstants.officeLongitude);
      expect(locationService.isWithinGeofence(), completion(isTrue));

      // Slightly outside 50m
      // 0.0005 degrees latitude is ~55.5 meters
      locationService.setMockLocation(AppConstants.officeLatitude + 0.0005, AppConstants.officeLongitude);
      expect(locationService.isWithinGeofence(), completion(isFalse));
    });
  });
}
