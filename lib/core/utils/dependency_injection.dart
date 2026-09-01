import 'package:flutter/material.dart';
import '../../repositories/ess_repository.dart';
import '../../repositories/mock_ess_repository.dart';
import '../../repositories/soap_ess_repository.dart';
import '../../services/location_service.dart';
import '../../services/soap/soap_client.dart';
import '../../services/soap/soap_config.dart';

class DependencyInjection {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static EssRepository? _repository;
  static LocationService? _locationService;

  static EssRepository get repository {
    _repository ??= MockEssRepository();
    return _repository!;
  }

  static LocationService get locationService {
    _locationService ??= GeolocatorLocationService();
    return _locationService!;
  }

  static void useSoapBackend(AppEnvironment env) {
    _repository = SoapEssRepository(SoapClient(
      env == AppEnvironment.uat ? SoapConfig.uat() : SoapConfig.prod(),
    ));
  }

  static void setDependencies({
    EssRepository? repository,
    LocationService? locationService,
  }) {
    if (repository != null) _repository = repository;
    if (locationService != null) _locationService = locationService;
  }
}
