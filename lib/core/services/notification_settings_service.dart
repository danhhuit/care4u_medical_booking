import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsService {
  NotificationSettingsService._();

  static final NotificationSettingsService instance =
      NotificationSettingsService._();

  static const String keyAppointmentReminder = 'appointment_reminder_enabled';
  static const String keyReminderMinutes = 'appointment_reminder_minutes';
  static const String keyAppointmentConfirmed =
      'appointment_confirmed_notification_enabled';
  static const String keyAppointmentCancelled =
      'appointment_cancelled_notification_enabled';
  static const String keyLabResult = 'lab_result_notification_enabled';

  Future<bool> getBool(String key, {bool defaultValue = true}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<int> getReminderMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyReminderMinutes) ?? 60;
  }

  Future<void> setReminderMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyReminderMinutes, minutes);
  }
}
