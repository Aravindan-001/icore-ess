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

class SessionExpiredException extends AppException {
  SessionExpiredException([String message = 'Session has expired. Please login again.'])
      : super(message, 'Session Error: ');
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, 'Validation Error: ');
}

class LocationException extends AppException {
  LocationException(String message) : super(message, 'Location Error: ');
}
