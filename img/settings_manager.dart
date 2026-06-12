import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  SettingsManager._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static final ValueNotifier<String> languageCode = ValueNotifier<String>('vi');
  static final ValueNotifier<int?> patientId = ValueNotifier<int?>(null);
  static final ValueNotifier<int?> doctorId = ValueNotifier<int?>(null);
  static final ValueNotifier<String> userRole = ValueNotifier<String>('guest');

  static bool _isLoggedIn = false;
  static bool get isLoggedIn => _isLoggedIn;

  static String? _patientUserId;
  static String? get currentPatientUserId => _patientUserId;

  static late SharedPreferences _prefs;

  static const String rolePatient = 'patient';
  static const String roleDoctor = 'doctor';
  static const String roleAdmin = 'admin';
  static const String roleGuest = 'guest';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final savedTheme = _prefs.getString('theme_mode');
    if (savedTheme != null) {
      themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    final savedLang = _prefs.getString('language_code');
    if (savedLang != null) {
      languageCode.value = savedLang;
    }

    _isLoggedIn = _prefs.getBool('is_logged_in') ?? false;
    userRole.value = _prefs.getString('current_user_role') ?? roleGuest;

    patientId.value = _prefs.getInt('current_patient_id');
    doctorId.value = _prefs.getInt('current_doctor_id');

    _patientUserId = _prefs.getString('current_user_id');
  }

  static Future<void> toggleTheme(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setString('theme_mode', isDark ? 'dark' : 'light');
  }

  static Future<void> setLanguage(String code) async {
    languageCode.value = code;
    await _prefs.setString('language_code', code);
  }

  static Future<void> setLoggedIn(bool value) async {
    if (!value) {
      await clearSession();
      return;
    }

    _isLoggedIn = true;
    await _prefs.setBool('is_logged_in', true);
  }

  static Future<void> setPatientSession({
    required int patientIdValue,
    String? account,
    String? email,
    String? phone,
    String? fullName,
    String? userId,
  }) async {
    _isLoggedIn = true;
    userRole.value = rolePatient;
    patientId.value = patientIdValue;
    doctorId.value = null;
    _patientUserId = userId;

    await _prefs.setBool('is_logged_in', true);
    await _prefs.setString('current_user_role', rolePatient);
    await _prefs.setInt('current_patient_id', patientIdValue);
    await _prefs.remove('current_doctor_id');
    await _prefs.remove('current_doctor_license');

    if (account != null && account.isNotEmpty) {
      await _prefs.setString('current_account', account);
    }

    if (email != null && email.isNotEmpty) {
      await _prefs.setString('current_email', email);
    }

    if (phone != null && phone.isNotEmpty) {
      await _prefs.setString('current_phone', phone);
    }

    if (fullName != null && fullName.isNotEmpty) {
      await _prefs.setString('current_full_name', fullName);
    }

    if (userId != null && userId.isNotEmpty) {
      await _prefs.setString('current_user_id', userId);
    } else {
      await _prefs.remove('current_user_id');
    }
  }

  static Future<void> setDoctorSession({
    required int doctorIdValue,
    String? account,
    String? email,
    String? phone,
    String? licenseNumber,
    String? userId,
  }) async {
    _isLoggedIn = true;
    userRole.value = roleDoctor;
    doctorId.value = doctorIdValue;
    patientId.value = null;
    _patientUserId = null;

    await _prefs.setBool('is_logged_in', true);
    await _prefs.setString('current_user_role', roleDoctor);
    await _prefs.setInt('current_doctor_id', doctorIdValue);
    await _prefs.remove('current_patient_id');

    if (account != null && account.isNotEmpty) {
      await _prefs.setString('current_account', account);
    }

    if (email != null && email.isNotEmpty) {
      await _prefs.setString('current_email', email);
    }

    if (phone != null && phone.isNotEmpty) {
      await _prefs.setString('current_phone', phone);
    }

    if (licenseNumber != null && licenseNumber.isNotEmpty) {
      await _prefs.setString('current_doctor_license', licenseNumber);
    }

    if (userId != null && userId.isNotEmpty) {
      await _prefs.setString('current_user_id', userId);
    } else {
      await _prefs.remove('current_user_id');
    }
  }

  static Future<void> setAdminSession({
    String? account,
    String? email,
    String? phone,
    String? userId,
  }) async {
    _isLoggedIn = true;
    userRole.value = roleAdmin;
    patientId.value = null;
    doctorId.value = null;
    _patientUserId = null;

    await _prefs.setBool('is_logged_in', true);
    await _prefs.setString('current_user_role', roleAdmin);
    await _prefs.remove('current_patient_id');
    await _prefs.remove('current_doctor_id');
    await _prefs.remove('current_doctor_license');

    if (account != null && account.isNotEmpty) {
      await _prefs.setString('current_account', account);
    }

    if (email != null && email.isNotEmpty) {
      await _prefs.setString('current_email', email);
    }

    if (phone != null && phone.isNotEmpty) {
      await _prefs.setString('current_phone', phone);
    }

    if (userId != null && userId.isNotEmpty) {
      await _prefs.setString('current_user_id', userId);
    } else {
      await _prefs.remove('current_user_id');
    }
  }

  static Future<void> clearSession() async {
    _isLoggedIn = false;
    userRole.value = roleGuest;
    patientId.value = null;
    doctorId.value = null;
    _patientUserId = null;

    await _prefs.setBool('is_logged_in', false);
    await _prefs.setString('current_user_role', roleGuest);
    await _prefs.remove('current_patient_id');
    await _prefs.remove('current_doctor_id');
    await _prefs.remove('current_account');
    await _prefs.remove('current_email');
    await _prefs.remove('current_phone');
    await _prefs.remove('current_full_name');
    await _prefs.remove('current_user_id');
    await _prefs.remove('current_doctor_license');
  }

  static bool get isDarkMode => themeMode.value == ThemeMode.dark;
  static String get currentLanguage => languageCode.value;

  static String get currentUserRole => userRole.value;
  static bool get isPatient => currentUserRole == rolePatient;
  static bool get isDoctor => currentUserRole == roleDoctor;
  static bool get isAdmin => currentUserRole == roleAdmin;

  static int get currentPatientId => patientId.value ?? 1;
  static int get currentDoctorId => doctorId.value ?? 1;

  static String? get currentAccount => _prefs.getString('current_account');
  static String? get currentEmail => _prefs.getString('current_email');
  static String? get currentPhone => _prefs.getString('current_phone');
  static String? get currentFullName => _prefs.getString('current_full_name');
  static String? get currentUserId => _prefs.getString('current_user_id');
  static String? get currentDoctorLicense =>
      _prefs.getString('current_doctor_license');
}
