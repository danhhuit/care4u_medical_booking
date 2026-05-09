import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class AppLogger {
  static void log(String message) {
    if (kDebugMode) {
      debugPrint('[Care4U] $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      developer.log('\x1B[34m[INFO]\x1B[0m $message', name: 'Care4U');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      developer.log('\x1B[33m[WARNING]\x1B[0m $message', name: 'Care4U');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        '\x1B[31m[ERROR]\x1B[0m $message',
        name: 'Care4U',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
