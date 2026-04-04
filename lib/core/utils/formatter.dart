/// ─── Formatter ───────────────────────────────────────────────────────────────
/// Tập hợp hàm định dạng dữ liệu hiển thị: tiền tệ, số điện thoại,
/// kích thước file, tên viết tắt, chuỗi rút gọn…
library;

class Formatter {
  Formatter._();

  // ── Tiền tệ (VND) ─────────────────────────────────────────────────────────

  /// Định dạng số tiền VNĐ với dấu `.` phân cách hàng nghìn.
  /// Ví dụ: `300000` → `"300.000 ₫"`
  static String currency(num amount, {bool showSymbol = true}) {
    final isNegative = amount < 0;
    final abs = amount.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = abs.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(abs[i]);
      count++;
    }
    final formatted = buffer.toString().split('').reversed.join();
    final sign = isNegative ? '-' : '';
    final symbol = showSymbol ? ' ₫' : '';
    return '$sign$formatted$symbol';
  }

  /// Định dạng tiền tệ ngắn gọn: `1500000` → `"1.5M ₫"` hoặc `"300K ₫"`.
  static String currencyShort(num amount) {
    final abs = amount.abs();
    String result;
    if (abs >= 1000000000) {
      result = '${(abs / 1000000000).toStringAsFixed(1)}B';
    } else if (abs >= 1000000) {
      result = '${(abs / 1000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000) {
      result = '${(abs / 1000).toStringAsFixed(0)}K';
    } else {
      result = abs.toStringAsFixed(0);
    }
    return '${amount < 0 ? '-' : ''}$result ₫';
  }

  /// Parse chuỗi tiền (có thể chứa dấu `.` và `₫`) về `double`.
  /// Ví dụ: `"300.000 ₫"` → `300000.0`
  static double? parseCurrency(String value) {
    final cleaned = value.replaceAll(RegExp(r'[₫.,\s]'), '');
    return double.tryParse(cleaned);
  }

  // ── Số điện thoại ─────────────────────────────────────────────────────────

  /// Che giấu số điện thoại: `"0912345678"` → `"091****678"`
  static String maskPhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'[\s\-.]'), '');
    if (clean.length < 7) return phone;
    return '${clean.substring(0, 3)}****${clean.substring(clean.length - 3)}';
  }

  /// Định dạng số điện thoại VN: `"0912345678"` → `"091 234 5678"`
  static String formatPhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'[\s\-.]'), '');
    if (clean.length == 10) {
      return '${clean.substring(0, 3)} ${clean.substring(3, 6)} ${clean.substring(6)}';
    }
    return phone;
  }

  // ── Họ tên & chữ viết tắt ────────────────────────────────────────────────

  /// Lấy chữ cái đầu của tên (phần cuối họ tên).
  /// `"Nguyễn Thành Danh"` → `"D"`
  static String initials(String fullName, {int maxChars = 2}) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    final chars = parts
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .toList();
    return chars.take(maxChars).join();
  }

  /// Lấy tên (phần cuối cùng sau dấu cách).
  /// `"Nguyễn Thành Danh"` → `"Danh"`
  static String firstName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? fullName : parts.last;
  }

  // ── Chuỗi rút gọn ────────────────────────────────────────────────────────

  /// Rút gọn chuỗi nếu quá [maxLength] ký tự, thêm `"…"`.
  static String truncate(String text, {int maxLength = 50}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }

  /// Rút gọn theo số từ (word count).
  static String truncateWords(String text, {int maxWords = 10}) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= maxWords) return text;
    return '${words.take(maxWords).join(' ')}…';
  }

  // ── Kích thước file ───────────────────────────────────────────────────────

  /// Chuyển byte về chuỗi dễ đọc: `"1.5 MB"`, `"230 KB"`, `"800 B"`.
  static String fileSize(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    } else if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    } else {
      return '$bytes B';
    }
  }

  // ── Điểm đánh giá ────────────────────────────────────────────────────────

  /// Định dạng điểm rating 1 chữ số thập phân: `4.8` → `"4.8 ★"`
  static String rating(double value) =>
      '${value.toStringAsFixed(1)} ★';

  // ── Số lượng ─────────────────────────────────────────────────────────────

  /// Rút gọn số lượng: `1234` → `"1.2K"`, `1500000` → `"1.5M"`.
  static String count(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // ── Mã hóa / ẩn email ────────────────────────────────────────────────────

  /// Ẩn phần user trong email: `"danh.nguyen@gmail.com"` → `"d***.n***@gmail.com"`
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty) return email;
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 2) return '${local[0]}***@$domain';
    final subParts = local.split('.');
    final masked = subParts.map((p) {
      if (p.isEmpty) return p;
      return '${p[0]}${'*' * (p.length - 1).clamp(1, 3)}';
    }).join('.');
    return '$masked@$domain';
  }

  // ── Giới tính ─────────────────────────────────────────────────────────────

  /// Label giới tính: `"male"` / `"Nam"` → `"Nam"`, `"female"` / `"Nữ"` → `"Nữ"`.
  static String genderLabel(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
      case 'nam':
        return 'Nam';
      case 'female':
      case 'nữ':
      case 'nu':
        return 'Nữ';
      default:
        return 'Khác';
    }
  }

  // ── Trạng thái lịch hẹn ──────────────────────────────────────────────────

  /// Label tiếng Việt cho trạng thái appointment.
  static String appointmentStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Đã xác nhận';
      case 'pending':
        return 'Chờ xác nhận';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  // ── Nhóm máu ─────────────────────────────────────────────────────────────

  /// Chuẩn hóa nhóm máu viết hoa: `"o+"` → `"O+"`.
  static String bloodType(String raw) => raw.trim().toUpperCase();
}
