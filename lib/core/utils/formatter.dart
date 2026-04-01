class Formatter {
  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 3)}';
  }
}
