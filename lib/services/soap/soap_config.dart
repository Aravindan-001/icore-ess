enum AppEnvironment {
  development,
  uat,
  production,
}

class SoapConfig {
  final AppEnvironment environment;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  SoapConfig({
    required this.environment,
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  // Factory methods for predefined environments
  // IMPORTANT: Do NOT hardcode real production endpoints here.
  // Use dart-define or other injection mechanisms for real credentials.

  factory SoapConfig.dev() {
    return SoapConfig(
      environment: AppEnvironment.development,
      baseUrl: 'https://dev-ess.ebaconnect.com/services',
    );
  }

  factory SoapConfig.uat() {
    return SoapConfig(
      environment: AppEnvironment.uat,
      baseUrl: 'https://uat-ess.ebaconnect.com/services',
    );
  }

  factory SoapConfig.prod() {
    return SoapConfig(
      environment: AppEnvironment.production,
      baseUrl: 'https://ess.ebaconnect.com/services',
    );
  }
}
