import 'package:flutter/foundation.dart';

final Stopwatch startupStopwatch = Stopwatch()..start();

void trace(String message) {
  debugPrint('[FORENSIC] ${startupStopwatch.elapsedMilliseconds}ms: $message');
}
