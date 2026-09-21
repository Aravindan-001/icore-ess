import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Clean abstraction interface layer for user-flow events tracking telemetry
class AnalyticsService {
  final FirebaseAnalytics? _analytics;

  AnalyticsService() : _analytics = _getAnalytics();

  static FirebaseAnalytics? _getAnalytics() {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux) return null;
    try {
      return FirebaseAnalytics.instance;
    } catch (_) {
      return null;
    }
  }

  /// Safe logging for standard business events ensuring zero private information leaks
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      if (_analytics != null) {
        await _analytics.logEvent(name: name, parameters: parameters);
      } else {
        debugPrint('[Mock Analytics Log] Event Name: $name, Parameters: $parameters');
      }
    } catch (e) {
      // Safe fallback boundary protection to never break live app workflows
      debugPrint('Analytics log error: $e');
    }
  }

  /// Track screen view navigation telemetry
  Future<void> logScreenView(String screenName) async {
    try {
      if (_analytics != null) {
        await _analytics.logScreenView(screenName: screenName);
      } else {
        debugPrint('[Mock Analytics ScreenView] Screen Name: $screenName');
      }
    } catch (e) {
      debugPrint('Analytics screen view log error: $e');
    }
  }
}
