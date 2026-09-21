/// Base class for all application-specific exceptions.
class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return "${prefix ?? ''}$message";
  }
}

class NetworkException extends AppException {
  NetworkException([String message = 'No Internet connection'])
      : super(message, 'Network Error: ');
}

class TimeoutException extends AppException {
  TimeoutException([String message = 'Request timeout'])
      : super(message, 'Timeout Error: ');
}

class ServerException extends AppException {
  ServerException([String message = 'Internal Server Error'])
      : super(message, 'Server Error: ');
}

class SoapFaultException extends AppException {
  final String? code;
  SoapFaultException(String message, [this.code])
      : super(message, 'SOAP Fault: ');
}

class AuthenticationException extends AppException {
  AuthenticationException([String message = 'Invalid credentials'])
      : super(message, 'Auth Error: ');
}

class AuthorizationException extends AppException {
  AuthorizationException([String message = 'Unauthorized access'])
      : super(message, 'Authorization Error: ');
}

class SessionExpiredException extends AppException {
  SessionExpiredException([String message = 'Session has expired. Please login again.'])
      : super(message, 'Session Error: ');
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, 'Validation Error: ');
}

class ParsingException extends AppException {
  ParsingException(String message) : super(message, 'Parsing Error: ');
}

class IntegrationException extends AppException {
  IntegrationException(String message) : super(message, 'Integration Error: ');
}

class LocationException extends AppException {
  LocationException(String message) : super(message, 'Location Error: ');
}
