import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => MockHttpClientRequest();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => MockHttpClientRequest();
  
  @override
  void noSuchMethod(Invocation invocation) {}
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  Encoding encoding = utf8;
  @override
  final HttpHeaders headers = MockHttpHeaders();
  
  @override
  Future<HttpClientResponse> close() async => MockHttpClientResponse();
  
  @override
  void noSuchMethod(Invocation invocation) {}
}

class MockHttpClientResponse implements HttpClientResponse {
  final List<int> _data = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82
  ]);

  @override
  int get statusCode => 200;
  @override
  int get contentLength => _data.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  
  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream.fromIterable([_data]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  void noSuchMethod(Invocation invocation) {}
}

class MockHttpHeaders implements HttpHeaders {
  @override
  void noSuchMethod(Invocation invocation) {}
}

void setupSecureStorageMock() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final Map<String, String> data = {};
  
  Future<dynamic> handler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'read':
        return data[methodCall.arguments['key']];
      case 'write':
        data[methodCall.arguments['key']] = methodCall.arguments['value'];
        return null;
      case 'delete':
        data.remove(methodCall.arguments['key']);
        return null;
      case 'deleteAll':
        data.clear();
        return null;
      case 'readAll':
        return data;
      default:
        return null;
    }
  }

  const channels = [
    'plugins.it_solutions.com.br/flutter_secure_storage',
    'plugins.it_nomads.com/flutter_secure_storage',
    'flutter_secure_storage',
  ];
  
  for (final channelName in channels) {
    final channel = MethodChannel(channelName);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, handler);
  }
}
