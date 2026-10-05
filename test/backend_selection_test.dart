import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/core/providers/injection_providers.dart';
import 'package:icore_ess/repositories/mock_ess_repository.dart';
import 'package:icore_ess/repositories/soap_ess_repository.dart';
import 'package:icore_ess/services/soap/soap_client.dart';
import 'package:icore_ess/services/soap/soap_config.dart';

void main() {
  group('Backend Selection & Fail-Closed Security Tests', () {
    test('Selects MockEssRepository when ESS_BACKEND=mock in non-release mode', () {
      final repository = selectEssRepository(
        backend: 'mock',
        isRelease: false,
        ref: _FakeRef(),
      );

      expect(repository, isA<MockEssRepository>());
    });

    test('Selects SoapEssRepository when ESS_BACKEND=soap', () {
      final repository = selectEssRepository(
        backend: 'soap',
        isRelease: false,
        ref: _FakeRef(),
      );

      expect(repository, isA<SoapEssRepository>());
    });

    test('Selects SoapEssRepository when ESS_BACKEND=soap in release mode', () {
      final repository = selectEssRepository(
        backend: 'soap',
        isRelease: true,
        ref: _FakeRef(),
      );

      expect(repository, isA<SoapEssRepository>());
    });

    test('Falls back to MockEssRepository in non-release mode when ESS_BACKEND is missing/empty', () {
      final repository = selectEssRepository(
        backend: '',
        isRelease: false,
        ref: _FakeRef(),
      );

      expect(repository, isA<MockEssRepository>());
    });

    test('Fails closed in release mode when ESS_BACKEND is missing/empty', () {
      expect(
        () => selectEssRepository(
          backend: '',
          isRelease: true,
          ref: _FakeRef(),
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('ESS_BACKEND configuration is missing in release build'),
          ),
        ),
      );
    });

    test('Fails closed in release mode when ESS_BACKEND=mock', () {
      expect(
        () => selectEssRepository(
          backend: 'mock',
          isRelease: true,
          ref: _FakeRef(),
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Mock backend (ESS_BACKEND=mock) is strictly prohibited in release builds'),
          ),
        ),
      );
    });

    test('Fails when ESS_BACKEND contains an unsupported value', () {
      expect(
        () => selectEssRepository(
          backend: 'invalid_backend',
          isRelease: false,
          ref: _FakeRef(),
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Unsupported backend "invalid_backend"'),
          ),
        ),
      );
    });

    test('Fails when ESS_BACKEND contains an unsupported value in release mode', () {
      expect(
        () => selectEssRepository(
          backend: 'invalid_backend',
          isRelease: true,
          ref: _FakeRef(),
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('Unsupported backend "invalid_backend"'),
          ),
        ),
      );
    });

    test('essRepositoryProvider operates correctly in Riverpod Container (default dev environment)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repository = container.read(essRepositoryProvider);
      expect(repository, isA<MockEssRepository>());
    });
  });
}

class _FakeRef implements Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #watch && invocation.positionalArguments.first == soapClientProvider) {
      return SoapClient(SoapConfig.dev());
    }
    return super.noSuchMethod(invocation);
  }
}
