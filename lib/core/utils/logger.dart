import 'package:flutter/foundation.dart';

/// A simple safe logger for development.
/// Ensures sensitive data is not logged in production.
class AppLogger {
  /// Logs an infrastructure event (e.g. SOAP request start)
  static void infra(String message) {
    if (kDebugMode) {
      debugPrint('[INFRA] $message');
    }
  }

  /// Logs an error with optional stack trace
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint(error.toString());
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }

  /// Logs a business event (e.g. Auth success) - Never log passwords or tokens here.
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }

  /// Warning logger
  static void warn(String message) {
    if (kDebugMode) {
      debugPrint('[WARN] $message');
    }
  }
}
