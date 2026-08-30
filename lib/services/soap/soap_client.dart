import 'soap_config.dart';

/// A service responsible for low-level SOAP/XML communication.
/// Implementation will be added once the WSDL and endpoint details are provided.
class SoapClient {
  final SoapConfig config;

  SoapClient(this.config);

  /// Sends a SOAP request and returns the parsed XML response.
  /// Currently throws UnimplementedError as the contract is pending.
  Future<String> post(String action, String xmlBody) async {
    // TODO: Implement using http or dio package once WSDL is available.
    // 1. Wrap body in SOAP Envelope
    // 2. Add required SOAP headers (Auth, Session, etc.)
    // 3. Send POST request to config.baseUrl
    // 4. Handle HTTP errors -> NetworkException/ServerException
    // 5. Parse SOAP Faults -> SoapFaultException
    
    throw UnimplementedError(
      'Waiting for client SOAP/WSDL contract at ${config.baseUrl}',
    );
  }
}
