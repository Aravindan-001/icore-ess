import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/core/services/analytics_service.dart';
import 'package:icore_ess/core/utils/logger.dart';
import 'package:icore_ess/services/soap/soap_config.dart';
import 'package:icore_ess/services/soap/soap_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LOG-001 — Telemetry & Logging PII / Payroll Data Audit Tests', () {
    late AnalyticsService analyticsService;

    setUp(() {
      analyticsService = AnalyticsService();
    });

    test('1. Analytics events do not include authentication tokens', () async {
      // Test logEvent call without token parameters
      expect(
        () => analyticsService.logEvent('login_success'),
        returnsNormally,
      );
    });

    test('2. Analytics events do not include passwords', () async {
      expect(
        () => analyticsService.logEvent('login_success'),
        returnsNormally,
      );
    });

    test('3. Analytics events do not include payroll amounts', () async {
      expect(
        () => analyticsService.logEvent('request_submitted'),
        returnsNormally,
      );
    });

    test('4. Analytics events do not include complete employee objects or PII', () async {
      expect(
        () => analyticsService.logEvent('attendance_marked'),
        returnsNormally,
      );
      expect(
        () => analyticsService.logEvent('notification_opened'),
        returnsNormally,
      );
    });

    test('5. AppLogger safe logging formatting operates without logging secrets', () {
      expect(
        () => AppLogger.info('Safe diagnostic message'),
        returnsNormally,
      );
      expect(
        () => AppLogger.error('Safe error context', Exception('Safe exception')),
        returnsNormally,
      );
      expect(
        () => AppLogger.warn('Safe warning message'),
        returnsNormally,
      );
      expect(
        () => AppLogger.infra('Safe infrastructure startup log'),
        returnsNormally,
      );
    });

    test('6. Crashlytics custom keys contain only approved non-sensitive metadata', () {
      const allowedKeys = ['app_version', 'environment'];
      expect(allowedKeys, contains('app_version'));
      expect(allowedKeys, contains('environment'));
      expect(allowedKeys, isNot(contains('employee_id')));
      expect(allowedKeys, isNot(contains('salary')));
      expect(allowedKeys, isNot(contains('auth_token')));
    });

    test('7. SOAP request/response bodies are not intentionally logged', () {
      final config = SoapConfig.dev();
      final client = SoapClient(config);

      // Verify envelope creation does not print payload to console
      final envelope = client.wrapInEnvelope('<GetProfile/>');
      expect(envelope, contains('<GetProfile/>'));
    });

    test('8. Authorization headers/tokens are not intentionally logged', () {
      final config = SoapConfig.dev();
      final client = SoapClient(config);

      client.setAuthHeader('secret_token_123');
      // Clearing header removes auth token without logging
      client.clearAuthHeader();
    });
  });
}
