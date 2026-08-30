import '../../repositories/ess_repository.dart';
import '../../repositories/mock_ess_repository.dart';
import '../../services/location_service.dart';

class DependencyInjection {
  static EssRepository _repository = MockEssRepository();
  static LocationService _locationService = GeolocatorLocationService();

  static EssRepository get repository => _repository;
  static LocationService get locationService => _locationService;

  // Method to override dependencies for testing
  static void setDependencies({
    EssRepository? repository,
    LocationService? locationService,
  }) {
    if (repository != null) _repository = repository;
    if (locationService != null) _locationService = locationService;
  }
}
