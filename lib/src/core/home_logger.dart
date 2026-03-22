import 'package:flutter/foundation.dart';

/// Internal diagnostic logger for the home_library rendering engine.
class HomeLogger {
  /// Toggle to enable or disable framework level logging.
  static bool enableLogging = false;

  static void info(String message) {
    if (enableLogging) {
      debugPrint('🟢 [HomeLibrary] $message');
    }
  }

  static void warn(String message) {
    if (enableLogging) {
      debugPrint('⚠️ [HomeLibrary] $message');
    }
  }

  static void error(String message) {
    // Errors are always logged if they trigger a framework fault, but we prefix it clearly
    debugPrint('🔴 [HomeLibrary] $message');
  }
}
