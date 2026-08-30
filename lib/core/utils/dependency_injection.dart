import '../../repositories/ess_repository.dart';
import '../../repositories/mock_ess_repository.dart';
import '../../repositories/soap_ess_repository.dart';
import '../../services/location_service.dart';
import '../../services/soap/soap_client.dart';
import '../../services/soap/soap_config.dart';

class DependencyInjection {
  static final EssRepository _mockRepository = MockEssRepository();
  
  static EssRepository _repository = _mockRepository;
  static LocationService _locationService = GeolocatorLocationService();

  static EssRepository get repository => _repository;
  static LocationService get locationService => _locationService;

  /// Switches the app to use the SOAP backend. 
  /// Requires implementation of SoapEssRepository.
  static void useSoapBackend(AppEnvironment env) {
    _repository = SoapEssRepository(SoapClient(
      env == AppEnvironment.uat ? SoapConfig.uat() : SoapConfig.prod(),
    ));
  }

  // Method to override dependencies for testing
  static void setDependencies({
    EssRepository? repository,
    LocationService? locationService,
  }) {
    if (repository != null) _repository = repository;
    if (locationService != null) _locationService = locationService;
  }
}
