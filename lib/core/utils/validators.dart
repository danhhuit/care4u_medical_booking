/// ─── Validators ─────────────────────────────────────────────────────────────
/// Tập hợp các hàm validate dùng chung cho Form fields trong toàn bộ ứng dụng.
/// Tất cả phương thức trả về `null` nếu hợp lệ, hoặc một chuỗi thông báo lỗi.
library;

class Validators {
  Validators._();

  // ── Hằng số RegExp ─────────────────────────────────────────────────────────
  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

  /// Số điện thoại Việt Nam: 0[3|5|7|8|9]xxxxxxxx (10 chữ số)
  static final _phoneVNRegex = RegExp(r'^(0)[35789]\d{8}$');

  /// Mật khẩu: ít nhất 8 ký tự, 1 chữ hoa, 1 chữ thường, 1 số
  static final _passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

  /// CCCD/CMT Việt Nam: 9 hoặc 12 số
  static final _nationalIdRegex = RegExp(r'^\d{9}(\d{3})?$');

  /// OTP: 4–6 chữ số
  static final _otpRegex = RegExp(r'^\d{4,6}$');

  /// URL đơn giản
  static final _urlRegex =
      RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-./?%&=]*)?$');

  // ── Trường bắt buộc ────────────────────────────────────────────────────────

  /// Kiểm tra trường không được để trống.
  static String? required(String? value, {String fieldName = 'Trường này'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  // ── Email ──────────────────────────────────────────────────────────────────

  /// Validate địa chỉ email.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email không được để trống';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Email không đúng định dạng (vd: ten@gmail.com)';
    }
    return null;
  }

  // ── Mật khẩu ──────────────────────────────────────────────────────────────

  /// Validate mật khẩu: ≥8 ký tự, có chữ hoa, chữ thường, số.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'Mật khẩu cần có chữ hoa, chữ thường và số';
    }
    return null;
  }

  /// Validate mật khẩu nhập lại khớp với mật khẩu gốc.
  static String? confirmPassword(String? value, String original) {
    final err = password(value);
    if (err != null) return err;
    if (value != original) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  // ── Số điện thoại ──────────────────────────────────────────────────────────

  /// Validate số điện thoại Việt Nam (10 chữ số, đầu 03/05/07/08/09).
  static String? phoneVN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Số điện thoại không được để trống';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-.]'), '');
    if (!_phoneVNRegex.hasMatch(cleaned)) {
      return 'Số điện thoại không hợp lệ (vd: 0912345678)';
    }
    return null;
  }

  // ── Họ tên ────────────────────────────────────────────────────────────────

  /// Validate họ tên: 2–60 ký tự, không chứa số hoặc ký tự đặc biệt.
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Họ tên không được để trống';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) return 'Họ tên phải có ít nhất 2 ký tự';
    if (trimmed.length > 60) return 'Họ tên không được quá 60 ký tự';
    if (RegExp(r'[0-9!@#\$%^&*()_+={}\[\]|\\:;"<>,.?/~`]')
        .hasMatch(trimmed)) {
      return 'Họ tên không được chứa số hoặc ký tự đặc biệt';
    }
    return null;
  }

  // ── Ngày sinh ─────────────────────────────────────────────────────────────

  /// Validate ngày sinh (ISO string yyyy-MM-dd). Tuổi hợp lệ: 0–120.
  static String? dateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ngày sinh không được để trống';
    }
    try {
      final dob = DateTime.parse(value.trim());
      final now = DateTime.now();
      if (dob.isAfter(now)) return 'Ngày sinh không được là ngày trong tương lai';
      final age = now.year - dob.year;
      if (age > 120) return 'Ngày sinh không hợp lệ';
      return null;
    } catch (_) {
      return 'Ngày sinh không đúng định dạng (yyyy-MM-dd)';
    }
  }

  // ── CCCD / CMT ────────────────────────────────────────────────────────────

  /// Validate CCCD (12 số) hoặc CMT (9 số) Việt Nam.
  static String? nationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Số CCCD/CMT không được để trống';
    }
    if (!_nationalIdRegex.hasMatch(value.trim())) {
      return 'CCCD phải có 12 số hoặc CMT có 9 số';
    }
    return null;
  }

  // ── OTP ───────────────────────────────────────────────────────────────────

  /// Validate mã OTP (4–6 chữ số).
  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mã OTP không được để trống';
    }
    if (!_otpRegex.hasMatch(value.trim())) {
      return 'Mã OTP phải là 4–6 chữ số';
    }
    return null;
  }

  // ── URL ───────────────────────────────────────────────────────────────────

  /// Validate URL (tuỳ chọn có http/https).
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    if (!_urlRegex.hasMatch(value.trim())) {
      return 'Địa chỉ URL không hợp lệ';
    }
    return null;
  }

  // ── Số nguyên / khoảng ───────────────────────────────────────────────────

  /// Validate chuỗi là số nguyên trong khoảng [min, max].
  static String? intRange(
    String? value, {
    int min = 0,
    int max = 999999999,
    String fieldName = 'Giá trị',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return '$fieldName phải là số nguyên';
    if (parsed < min || parsed > max) {
      return '$fieldName phải từ $min đến $max';
    }
    return null;
  }

  // ── Độ dài chuỗi ─────────────────────────────────────────────────────────

  /// Validate độ dài chuỗi trong khoảng [minLen, maxLen].
  static String? length(
    String? value, {
    int minLen = 1,
    int maxLen = 255,
    String fieldName = 'Trường này',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName không được để trống';
    }
    if (value.trim().length < minLen) {
      return '$fieldName phải có ít nhất $minLen ký tự';
    }
    if (value.trim().length > maxLen) {
      return '$fieldName không được quá $maxLen ký tự';
    }
    return null;
  }

  // ── Số tiền VND ───────────────────────────────────────────────────────────

  /// Validate số tiền hợp lệ; phải là số dương và không vượt quá max.
  static String? money(
    String? value, {
    double min = 1000,
    double max = 1000000000,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Số tiền không được để trống';
    }
    final cleaned = value.replaceAll(RegExp(r'[.,\s]'), '');
    final amount = double.tryParse(cleaned);
    if (amount == null) return 'Số tiền không hợp lệ';
    if (amount < min) return 'Số tiền tối thiểu là ${min.toStringAsFixed(0)}đ';
    if (amount > max) return 'Số tiền tối đa là ${max.toStringAsFixed(0)}đ';
    return null;
  }
}
