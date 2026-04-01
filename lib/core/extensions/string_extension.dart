/// Extension bổ sung trên [String] dùng chung trong toàn ứng dụng.
library;

extension StringExtension on String {
  // ── Viết hoa ──────────────────────────────────────────────────────────────

  /// Viết hoa chữ cái đầu tiên: `"hello"` → `"Hello"`.
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Viết hoa chữ đầu của mỗi từ (Title Case):
  /// `"nguyễn văn an"` → `"Nguyễn Văn An"`.
  String get titleCase {
    return split(' ').map((w) => w.isEmpty ? w : w.capitalize).join(' ');
  }

  // ── Kiểm tra ──────────────────────────────────────────────────────────────

  /// `true` nếu chuỗi là địa chỉ email hợp lệ.
  bool get isEmail =>
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
          .hasMatch(this);

  /// `true` nếu chuỗi là số điện thoại VN hợp lệ (10 số, bắt đầu 03/05/07/08/09).
  bool get isPhoneVN =>
      RegExp(r'^(0)[35789]\d{8}$').hasMatch(replaceAll(RegExp(r'[\s\-.]'), ''));

  /// `true` nếu chuỗi chỉ chứa chữ số.
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  /// `true` nếu chuỗi rỗng hoặc chỉ chứa khoảng trắng.
  bool get isBlank => trim().isEmpty;

  /// `true` nếu chuỗi KHÔNG rỗng và không chỉ khoảng trắng.
  bool get isNotBlank => trim().isNotEmpty;

  // ── Biến đổi ──────────────────────────────────────────────────────────────

  /// Rút gọn chuỗi nếu quá [maxLength], thêm `"…"`.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}…';
  }

  /// Xóa toàn bộ khoảng trắng trong chuỗi: `"0 91 234"` → `"091234"`.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Chuyển camelCase sang snake_case: `"doctorName"` → `"doctor_name"`.
  String get toSnakeCase =>
      replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m.group(0)!.toLowerCase()}')
          .replaceFirst(RegExp(r'^_'), '');

  /// Chuyển snake_case sang camelCase: `"doctor_name"` → `"doctorName"`.
  String get toCamelCase {
    final parts = split('_');
    if (parts.isEmpty) return this;
    return parts.first +
        parts.skip(1).map((p) => p.isEmpty ? '' : p.capitalize).join();
  }

  // ── Định dạng số điện thoại ───────────────────────────────────────────────

  /// Định dạng số điện thoại VN: `"0912345678"` → `"091 234 5678"`.
  String get formatPhone {
    final clean = removeWhitespace;
    if (clean.length == 10) {
      return '${clean.substring(0, 3)} ${clean.substring(3, 6)} ${clean.substring(6)}';
    }
    return this;
  }

  // ── Tiếng Việt ───────────────────────────────────────────────────────────

  /// Loại bỏ dấu tiếng Việt: `"Nguyễn"` → `"Nguyen"`.
  String get removeVietnameseDiacritics {
    const from =
        'àáâãäåạảấầẩẫậắằẳẵặăăÀÁÂÃÄÅẠẢẤẦẨẪẬẮẰẲẴẶĂ'
        'èéêëẹẻẽếềểễệêÈÉÊËẸẺẼẾỀỂỄỆ'
        'ìíîïịỉĩÌÍÎÏỊỈĨ'
        'òóôõöọỏốồổỗộớờởỡợơôÒÓÔÕÖỌỎỐỒỔỖỘỚỜỞỠỢƠ'
        'ùúûüụủũưứừửữựÙÚÛÜỤỦŨƯỨỪỬỮỰ'
        'ýỳỵỷỹÝỲỴỶỸ'
        'đĐ'
        'ñÑ';
    const to =
        'aaaaaaaaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAA'
        'eeeeeeeeeeeeeeeEEEEEEEEEEEEEEE'
        'iiiiiiiIIIIIII'
        'oooooooooooooooooooooooOOOOOOOOOOOOOOOOOOOOOO'
        'uuuuuuuuuuuuuuUUUUUUUUUUUUUU'
        'yyyyyYYYYY'
        'dD'
        'nN';

    String result = this;
    for (int i = 0; i < from.length; i++) {
      result = result.replaceAll(from[i], to[i]);
    }
    return result;
  }

  /// Tìm kiếm không phân biệt hoa thường và dấu tiếng Việt.
  bool containsIgnoreDiacritics(String query) {
    return removeVietnameseDiacritics
        .toLowerCase()
        .contains(query.removeVietnameseDiacritics.toLowerCase());
  }
}
