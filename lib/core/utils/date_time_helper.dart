/// ─── DateTimeHelper ──────────────────────────────────────────────────────────
/// Tiện ích xử lý và định dạng ngày giờ dùng chung trong toàn ứng dụng.
library;

class DateTimeHelper {
  DateTimeHelper._();

  // ── Hằng số tên tháng / ngày ────────────────────────────────────────────

  static const _monthsVi = [
    '', // index 0 unused
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4',
    'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8',
    'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
  ];

  static const _weekdaysVi = [
    '', // index 0 unused
    'Thứ Hai', 'Thứ Ba', 'Thứ Tư',
    'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật',
  ];

  static const _monthsEn = [
    '',
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  static const _weekdaysEn = [
    '',
    'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  // ── Điền số 0 ────────────────────────────────────────────────────────────

  static String _pad(int n) => n.toString().padLeft(2, '0');

  // ── Định dạng ngày ─────────────────────────────────────────────────────

  /// `dd/MM/yyyy` — định dạng ngắn phổ biến ở Việt Nam.
  /// Ví dụ: `05/04/2026`
  static String formatDate(DateTime date) =>
      '${_pad(date.day)}/${_pad(date.month)}/${date.year}';

  /// `dd/MM/yyyy` từ chuỗi ISO. Trả `'—'` nếu parse thất bại.
  static String formatDateFromString(String isoString) {
    try {
      return formatDate(DateTime.parse(isoString));
    } catch (_) {
      return '—';
    }
  }

  /// `yyyy-MM-dd` — định dạng ISO lưu database.
  static String toIsoDate(DateTime date) =>
      '${date.year}-${_pad(date.month)}-${_pad(date.day)}';

  /// `HH:mm` — giờ và phút (24h).
  static String formatTime(DateTime date) =>
      '${_pad(date.hour)}:${_pad(date.minute)}';

  /// `HH:mm:ss` — giờ đầy đủ có giây.
  static String formatTimeFull(DateTime date) =>
      '${_pad(date.hour)}:${_pad(date.minute)}:${_pad(date.second)}';

  /// `dd/MM/yyyy HH:mm` — ngày giờ đầy đủ.
  static String formatDateTime(DateTime date) =>
      '${formatDate(date)} ${formatTime(date)}';

  /// `dd/MM/yyyy HH:mm` từ chuỗi ISO.
  static String formatDateTimeFromString(String isoString) {
    try {
      return formatDateTime(DateTime.parse(isoString));
    } catch (_) {
      return '—';
    }
  }

  // ── Tên tháng / ngày trong tuần ──────────────────────────────────────────

  /// `"Thứ Hai, 05 Tháng 4 2026"` — dài, tiếng Việt.
  static String formatDateLongVi(DateTime date) {
    final wd = _weekdaysVi[date.weekday];
    final m = _monthsVi[date.month];
    return '$wd, ${_pad(date.day)} $m ${date.year}';
  }

  /// `"Monday, April 05 2026"` — dài, tiếng Anh.
  static String formatDateLongEn(DateTime date) {
    final wd = _weekdaysEn[date.weekday];
    final m = _monthsEn[date.month];
    return '$wd, $m ${_pad(date.day)} ${date.year}';
  }

  /// Tên ngày trong tuần (tiếng Việt): `"Thứ Hai"` ... `"Chủ Nhật"`.
  static String weekdayVi(DateTime date) => _weekdaysVi[date.weekday];

  /// Tên ngày trong tuần ngắn (tiếng Việt): `"T2"` ... `"CN"`.
  static String weekdayShortVi(DateTime date) {
    const shorts = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return shorts[date.weekday];
  }

  /// Tên tháng tiếng Việt: `"Tháng 4"`.
  static String monthVi(DateTime date) => _monthsVi[date.month];

  // ── Thời gian tương đối ──────────────────────────────────────────────────

  /// Trả về chuỗi kiểu `"2 giờ trước"`, `"vừa xong"`, `"5 ngày trước"`.
  static String timeAgo(DateTime dateTime, {bool short = false}) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return short ? 'Vừa xong' : 'Vừa xong';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return short ? '${m}ph' : '$m phút trước';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return short ? '${h}g' : '$h giờ trước';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return short ? '${d}n' : '$d ngày trước';
    } else if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return short ? '${w}t' : '$w tuần trước';
    } else if (diff.inDays < 365) {
      final mo = (diff.inDays / 30).floor();
      return short ? '${mo}th' : '$mo tháng trước';
    } else {
      final y = (diff.inDays / 365).floor();
      return short ? '${y}n' : '$y năm trước';
    }
  }

  /// `timeAgo` từ chuỗi ISO; trả `''` nếu lỗi.
  static String timeAgoFromString(String isoString, {bool short = false}) {
    try {
      return timeAgo(DateTime.parse(isoString), short: short);
    } catch (_) {
      return '';
    }
  }

  // ── Khoảng thời gian còn lại ─────────────────────────────────────────────

  /// `"Còn 3 ngày"`, `"Còn 2 giờ 30 phút"`, `"Đã qua"`.
  static String timeUntil(DateTime future) {
    final diff = future.difference(DateTime.now());
    if (diff.isNegative) return 'Đã qua';
    if (diff.inDays > 0) {
      return 'Còn ${diff.inDays} ngày';
    } else if (diff.inHours > 0) {
      final m = diff.inMinutes % 60;
      return m > 0
          ? 'Còn ${diff.inHours} giờ $m phút'
          : 'Còn ${diff.inHours} giờ';
    } else {
      return 'Còn ${diff.inMinutes} phút';
    }
  }

  // ── Tính tuổi ────────────────────────────────────────────────────────────

  /// Tính tuổi từ ngày sinh tới hôm nay.
  static int ageFromDob(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  /// Tính tuổi từ chuỗi ISO `"yyyy-MM-dd"`.
  static int? ageFromString(String isoString) {
    try {
      return ageFromDob(DateTime.parse(isoString));
    } catch (_) {
      return null;
    }
  }

  // ── Kiểm tra ngày ────────────────────────────────────────────────────────

  /// `true` nếu [date] là hôm nay.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// `true` nếu [date] là ngày mai.
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// `true` nếu [date] đã qua (quá khứ, không tính hôm nay).
  static bool isPast(DateTime date) =>
      date.isBefore(DateTime.now()) && !isToday(date);

  /// `true` nếu [date] là ngày trong tương lai (không tính hôm nay).
  static bool isFuture(DateTime date) =>
      date.isAfter(DateTime.now()) && !isToday(date);

  // ── Label thân thiện cho lịch hẹn ──────────────────────────────────────

  /// Trả nhãn phù hợp: `"Hôm nay"`, `"Ngày mai"`, hoặc `"dd/MM/yyyy"`.
  static String appointmentDateLabel(DateTime date) {
    if (isToday(date)) return 'Hôm nay';
    if (isTomorrow(date)) return 'Ngày mai';
    return formatDate(date);
  }

  /// Giống trên nhưng nhận chuỗi ISO.
  static String appointmentDateLabelFromString(String isoString) {
    try {
      return appointmentDateLabel(DateTime.parse(isoString));
    } catch (_) {
      return isoString;
    }
  }

  // ── Tính thời lượng ──────────────────────────────────────────────────────

  /// Chuyển [Duration] thành chuỗi thân thiện: `"1 giờ 30 phút"`.
  static String formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    if (h > 0 && m > 0) return '$h giờ $m phút';
    if (h > 0) return '$h giờ';
    return '$m phút';
  }

  // ── Parse ngày Việt Nam ──────────────────────────────────────────────────

  /// Parse chuỗi `"dd/MM/yyyy"` → [DateTime]. Ném [FormatException] nếu lỗi.
  static DateTime parseVnDate(String ddmmyyyy) {
    final parts = ddmmyyyy.split('/');
    if (parts.length != 3) throw FormatException('Invalid date: $ddmmyyyy');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  // ── Danh sách ngày trong tháng ───────────────────────────────────────────

  /// Trả danh sách tất cả [DateTime] trong tháng [year]/[month].
  static List<DateTime> daysInMonth(int year, int month) {
    final first = DateTime(year, month, 1);
    final last = DateTime(year, month + 1, 0);
    return List.generate(
      last.day,
      (i) => first.add(Duration(days: i)),
    );
  }

  // ── Ngày đầu / cuối tuần ─────────────────────────────────────────────────

  /// Ngày Thứ Hai của tuần chứa [date].
  static DateTime startOfWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));

  /// Ngày Chủ Nhật của tuần chứa [date].
  static DateTime endOfWeek(DateTime date) =>
      date.add(Duration(days: 7 - date.weekday));
}
