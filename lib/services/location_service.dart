import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../core/constants/app_constants.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double distanceFromOffice;
  final bool isWithinGeofence;
  final bool isMocked;
  final String? errorMessage;
  final bool isPermissionDenied;
  final bool isPermissionDeniedForever;
  final bool isLocationServiceDisabled;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.distanceFromOffice,
    required this.isWithinGeofence,
    this.isMocked = false,
    this.errorMessage,
    this.isPermissionDenied = false,
    this.isPermissionDeniedForever = false,
    this.isLocationServiceDisabled = false,
  });

  factory LocationResult.error(String message, {
    bool isPermissionDenied = false,
    bool isPermissionDeniedForever = false,
    bool isLocationServiceDisabled = false,
  }) {
    return LocationResult(
      latitude: 0,
      longitude: 0,
      accuracy: 0,
      distanceFromOffice: double.infinity,
      isWithinGeofence: false,
      isMocked: false,
      errorMessage: message,
      isPermissionDenied: isPermissionDenied,
      isPermissionDeniedForever: isPermissionDeniedForever,
      isLocationServiceDisabled: isLocationServiceDisabled,
    );
  }
}

abstract class LocationService {
  Future<LocationResult> getLocationDetails();
  
  /// Opens the device location settings or app settings.
  Future<void> openLocationSettings();
  
  // Keep these for backward compatibility if needed, but prefer getLocationDetails
  Future<double> getDistanceFromOffice();
  Future<bool> isWithinGeofence();
}

mixin LocationCalculator {
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000; // Result in meters
  }
}

class MockLocationService with LocationCalculator implements LocationService {
  double mockLat = AppConstants.officeLatitude;
  double mockLon = AppConstants.officeLongitude;
  double mockAccuracy = 5.0;

  void setMockLocation(double lat, double lon, {double accuracy = 5.0}) {
    mockLat = lat;
    mockLon = lon;
    mockAccuracy = accuracy;
  }

  @override
  Future<LocationResult> getLocationDetails() async {
    final distance = calculateDistance(
      mockLat,
      mockLon,
      AppConstants.officeLatitude,
      AppConstants.officeLongitude,
    );
    return LocationResult(
      latitude: mockLat,
      longitude: mockLon,
      accuracy: mockAccuracy,
      distanceFromOffice: distance,
      isWithinGeofence: distance <= AppConstants.allowedRadiusInMeters && 
                       mockAccuracy <= AppConstants.maxAllowedAccuracyInMeters,
    );
  }

  @override
  Future<double> getDistanceFromOffice() async {
    final details = await getLocationDetails();
    return details.distanceFromOffice;
  }

  @override
  Future<bool> isWithinGeofence() async {
    final details = await getLocationDetails();
    return details.isWithinGeofence;
  }

  @override
  Future<void> openLocationSettings() async {
    // No-op for mock
  }
}

class GeolocatorLocationService with LocationCalculator implements LocationService {
  @override
  Future<LocationResult> getLocationDetails() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.error(
          'Location services are disabled.',
          isLocationServiceDisabled: true,
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.error(
            'Location permissions are denied.',
            isPermissionDenied: true,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.error(
          'Location permissions are permanently denied.',
          isPermissionDeniedForever: true,
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final distance = calculateDistance(
        position.latitude,
        position.longitude,
        AppConstants.officeLatitude,
        AppConstants.officeLongitude,
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        distanceFromOffice: distance,
        isWithinGeofence: distance <= AppConstants.allowedRadiusInMeters && 
                         position.accuracy <= AppConstants.maxAllowedAccuracyInMeters,
        isMocked: position.isMocked,
      );
    } catch (e) {
      return LocationResult.error('Failed to get location: $e');
    }
  }

  @override
  Future<double> getDistanceFromOffice() async {
    final details = await getLocationDetails();
    return details.distanceFromOffice;
  }

  @override
  Future<bool> isWithinGeofence() async {
    final details = await getLocationDetails();
    return details.isWithinGeofence;
  }

  @override
  Future<void> openLocationSettings() async {
    await Geolocator.openAppSettings();
  }
}
