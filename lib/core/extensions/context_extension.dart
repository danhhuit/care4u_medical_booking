/// Extension bổ sung trên [BuildContext] dùng chung trong toàn ứng dụng.
library;

import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // ── Theme & MediaQuery cơ bản ─────────────────────────────────────────────

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get statusBarHeight => MediaQuery.paddingOf(this).top;
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// `true` nếu bàn phím đang hiển thị
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;

  // ── Responsive breakpoints ────────────────────────────────────────────────

  /// `true` nếu màn hình nhỏ hơn 600px (phone).
  bool get isPhone => screenWidth < 600;

  /// `true` nếu màn hình từ 600–1024px (tablet).
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// `true` nếu màn hình từ 1024px trở lên (desktop).
  bool get isDesktop => screenWidth >= 1024;

  // ── Navigation shortcuts ──────────────────────────────────────────────────

  /// Push một route có tên.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);

  /// Replace route hiện tại bằng route mới.
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(
        this,
      ).pushReplacementNamed<T, dynamic>(routeName, arguments: arguments);

  /// Pop về màn hình trước.
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Pop về root (ví dụ sau đăng nhập).
  void popUntilRoot() => Navigator.of(this).popUntil((route) => route.isFirst);

  // ── SnackBar shortcuts ────────────────────────────────────────────────────

  /// Hiện SnackBar thông thường.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Hiện SnackBar thành công (xanh lá).
  void showSuccessSnackBar(String message) =>
      showSnackBar(message, backgroundColor: const Color(0xFF2E7D32));

  /// Hiện SnackBar lỗi (đỏ).
  void showErrorSnackBar(String message) =>
      showSnackBar(message, backgroundColor: const Color(0xFFD32F2F));

  /// Hiện SnackBar cảnh báo (cam).
  void showWarningSnackBar(String message) =>
      showSnackBar(message, backgroundColor: Colors.orange.shade700);

  // ── Dialog shortcuts ──────────────────────────────────────────────────────

  /// Hiện dialog xác nhận. Trả `true` nếu người dùng nhấn "Có".
  Future<bool> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    Color confirmColor = Colors.red,
  }) async {
    final result = await showDialog<bool>(
      context: this,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ── Loading dialog ────────────────────────────────────────────────────────

  /// Hiện dialog loading. Gọi `Navigator.pop()` để đóng.
  void showLoadingDialog({String message = 'Đang xử lý...'}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Expanded(child: Text(message)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Focus ─────────────────────────────────────────────────────────────────

  /// Ẩn bàn phím bằng cách unfocus.
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
