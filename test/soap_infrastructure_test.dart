import 'package:flutter_test/flutter_test.dart';
import 'package:icore_ess/core/errors/app_exceptions.dart';
import 'package:icore_ess/services/soap/soap_config.dart';
import 'package:icore_ess/services/soap/soap_client.dart';
import 'package:icore_ess/services/soap/xml_utils.dart';

void main() {
  group('SOAP Infrastructure & Exceptions Verification', () {
    test('SoapConfig creates correct environment setups with defaults', () {
      final devConfig = SoapConfig.dev();
      final uatConfig = SoapConfig.uat();
      final prodConfig = SoapConfig.prod();

      expect(devConfig.environment, AppEnvironment.development);
      expect(uatConfig.environment, AppEnvironment.uat);
      expect(prodConfig.environment, AppEnvironment.production);

      expect(devConfig.baseUrl, contains('dev-ess.ebaconnect.com'));
      expect(uatConfig.baseUrl, contains('uat-ess.ebaconnect.com'));
      expect(prodConfig.baseUrl, contains('ess.ebaconnect.com'));
    });

    test('SoapClient wrapInEnvelope generates syntactically valid generic envelope structure', () {
      final config = SoapConfig.dev();
      final client = SoapClient(config);
      const fakeBody = '<GetProfile><EmployeeID>EMP001</EmployeeID></GetProfile>';

      final envelope = client.wrapInEnvelope(fakeBody);

      expect(envelope, contains('<?xml version="1.0" encoding="utf-8"?>'));
      expect(envelope, contains('<soap:Envelope'));
      expect(envelope, contains('<soap:Body>'));
      expect(envelope, contains(fakeBody));
    });

    test('SoapClient post throws IntegrationException for pending contract', () async {
      final config = SoapConfig.dev();
      final client = SoapClient(config);

      expect(
        () => client.post('GetProfile', '<GetProfile/>'),
        throwsA(isA<IntegrationException>()),
      );
    });

    test('XmlUtils extraction and wrapping logic', () {
      const xml = '<Response><Result>Success</Result></Response>';
      expect(XmlUtils.getTagContent(xml, 'Result'), 'Success');
      expect(XmlUtils.getTagContent(xml, 'Missing'), null);
      
      expect(XmlUtils.wrapTag('Name', 'ebaConnect'), '<Name>ebaConnect</Name>');
      expect(XmlUtils.wrapTag('Status', null), '<Status xsi:nil="true" />');
      
      expect(XmlUtils.escape('A & B < C > D " E \' F'), 'A &amp; B &lt; C &gt; D &quot; E &apos; F');
      
      expect(XmlUtils.isSoapFault('<soap:Fault><faultcode>Server</faultcode></soap:Fault>'), true);
      expect(XmlUtils.isSoapFault('<Response>OK</Response>'), false);
    });

    test('AppExceptions differentiate timeout, authorization, and network failure types', () {
      final networkEx = NetworkException('No connection');
      final timeoutEx = TimeoutException('Connection timeout');
      final authEx = AuthenticationException('Invalid credentials');
      final authorEx = AuthorizationException('Forbidden resource');
      final soapEx = SoapFaultException('Internal soap error', 'SOAP-ENV:Server');
      final integEx = IntegrationException('Contract missing');

      expect(networkEx.toString(), contains('Network Error:'));
      expect(timeoutEx.toString(), contains('Timeout Error:'));
      expect(authEx.toString(), contains('Auth Error:'));
      expect(authorEx.toString(), contains('Authorization Error:'));
      expect(soapEx.toString(), contains('SOAP Fault:'));
      expect(integEx.toString(), contains('Integration Error:'));
      expect(soapEx.code, 'SOAP-ENV:Server');
    });
  });
}
