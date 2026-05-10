/// ─── AppLogger ───────────────────────────────────────────────────────────────
/// Logger phân cấp (DEBUG / INFO / WARNING / ERROR) chỉ hoạt động ở debug mode.
/// Hỗ trợ: timestamp, emoji tag, tên tag tùy chỉnh, và log lỗi có stack trace.
library;

import 'package:flutter/foundation.dart';

/// Mức độ log.
enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  // ── Cấu hình ─────────────────────────────────────────────────────────────

  /// Đặt `false` để tắt toàn bộ log (kể cả debug mode).
  static bool enabled = true;

  /// Mức log tối thiểu sẽ được in ra. Mặc định: [LogLevel.debug].
  static LogLevel minLevel = LogLevel.debug;

  /// `true` → thêm timestamp vào mỗi dòng log.
  static bool showTimestamp = true;

  // ── Nội bộ ────────────────────────────────────────────────────────────────

  static final _emoji = {
    LogLevel.debug: '🔍',
    LogLevel.info: '✅',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
  };

  static final _label = {
    LogLevel.debug: 'DEBUG',
    LogLevel.info: 'INFO ',
    LogLevel.warning: 'WARN ',
    LogLevel.error: 'ERROR',
  };

  static bool _shouldLog(LogLevel level) {
    if (!enabled) return false;
    if (!kDebugMode) return false;
    return level.index >= minLevel.index;
  }

  static String _timestamp() {
    if (!showTimestamp) return '';
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    final ms = now.millisecond.toString().padLeft(3, '0');
    return '[$h:$m:$s.$ms] ';
  }

  static void _print(LogLevel level, String tag, String message,
      {Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(level)) return;
    final ts = _timestamp();
    final emoji = _emoji[level]!;
    final lbl = _label[level]!;
    final prefix = '$ts$emoji [$lbl][Care4U/$tag]';

    debugPrint('$prefix $message');
    if (error != null) debugPrint('$prefix Error: $error');
    if (stackTrace != null) {
      // Print first 6 lines of stack trace to avoid flooding console
      final lines = stackTrace.toString().split('\n').take(6);
      for (final line in lines) {
        debugPrint('$prefix   $line');
      }
    }
  }

  // ── API công khai ─────────────────────────────────────────────────────────

  /// Log mức **DEBUG** — chi tiết kỹ thuật nội bộ.
  /// ```dart
  /// AppLogger.d('BookingVM', 'fetchSlots called');
  /// ```
  static void d(String tag, String message) =>
      _print(LogLevel.debug, tag, message);

  /// Log mức **INFO** — sự kiện bình thường đáng chú ý.
  /// ```dart
  /// AppLogger.i('Auth', 'User logged in: danh@gmail.com');
  /// ```
  static void i(String tag, String message) =>
      _print(LogLevel.info, tag, message);

  /// Log mức **WARNING** — tình huống bất thường nhưng không nghiêm trọng.
  /// ```dart
  /// AppLogger.w('Network', 'Response took > 3s');
  /// ```
  static void w(String tag, String message) =>
      _print(LogLevel.warning, tag, message);

  /// Log mức **ERROR** — lỗi nghiêm trọng; kèm exception và stack trace.
  /// ```dart
  /// AppLogger.e('Payment', 'Transaction failed', error: e, stackTrace: st);
  /// ```
  static void e(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _print(LogLevel.error, tag, message,
          error: error, stackTrace: stackTrace);

  // ── API ngắn (không cần tag) ─────────────────────────────────────────────

  /// Log nhanh mức INFO không cần tag: `AppLogger.log('something happened')`.
  static void log(String message, {String tag = 'App'}) =>
      i(tag, message);

  // ── Group log ─────────────────────────────────────────────────────────────

  /// In tiêu đề phân cách đẹp khi bắt đầu một nhóm log.
  /// ```dart
  /// AppLogger.group('Appointment Flow');
  /// ```
  static void group(String title) {
    if (!_shouldLog(LogLevel.debug)) return;
    final bar = '─' * (40 - title.length ~/ 2).clamp(5, 40);
    debugPrint('$bar $title $bar');
  }

  // ── JSON log ─────────────────────────────────────────────────────────────

  /// In Map/List theo dạng dễ đọc (từng key trên một dòng).
  static void json(String tag, Map<String, dynamic> data) {
    if (!_shouldLog(LogLevel.debug)) return;
    _print(LogLevel.debug, tag, '{');
    for (final entry in data.entries) {
      debugPrint('   "${entry.key}": ${entry.value}');
    }
    debugPrint('}');
  }

  // ── Network log helpers ───────────────────────────────────────────────────

  /// Log HTTP request.
  static void request(String method, String url, {Map<String, dynamic>? body}) {
    if (!_shouldLog(LogLevel.debug)) return;
    _print(LogLevel.debug, 'HTTP', '→ $method $url');
    if (body != null) json('REQ', body);
  }

  /// Log HTTP response.
  static void response(int statusCode, String url, {Object? body}) {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
    _print(level, 'HTTP', '← [$statusCode] $url');
    if (body != null) debugPrint('   Response: $body');
  }

  // ── Performance log ───────────────────────────────────────────────────────

  /// Đo thời gian thực thi của [task] và log kết quả.
  ///
  /// ```dart
  /// final result = await AppLogger.measure('fetchDoctors', () => api.getDoctors());
  /// ```
  static Future<T> measure<T>(String label, Future<T> Function() task) async {
    final sw = Stopwatch()..start();
    try {
      final result = await task();
      sw.stop();
      i('PERF', '$label completed in ${sw.elapsedMilliseconds}ms');
      return result;
    } catch (e, st) {
      sw.stop();
      AppLogger.e('PERF', '$label FAILED after ${sw.elapsedMilliseconds}ms',
          error: e, stackTrace: st);
      rethrow;
    }
  }
}
