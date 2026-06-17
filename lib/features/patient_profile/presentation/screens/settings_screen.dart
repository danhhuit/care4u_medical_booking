import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/core/services/notification_settings_service.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/change_password_screen.dart';
import 'package:care4u_medical_booking/features/patient_profile/presentation/screens/user_guide_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settings = NotificationSettingsService.instance;

  bool _appointmentReminder = true;
  bool _appointmentConfirmed = true;
  bool _appointmentCancelled = true;
  bool _labResult = true;
  bool _darkMode = false;
  int _reminderMinutes = 60;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final appointmentReminder = await _settings.getBool(
      NotificationSettingsService.keyAppointmentReminder,
    );
    final appointmentConfirmed = await _settings.getBool(
      NotificationSettingsService.keyAppointmentConfirmed,
    );
    final appointmentCancelled = await _settings.getBool(
      NotificationSettingsService.keyAppointmentCancelled,
    );
    final labResult = await _settings.getBool(
      NotificationSettingsService.keyLabResult,
    );
    final reminderMinutes = await _settings.getReminderMinutes();

    if (!mounted) return;

    setState(() {
      _appointmentReminder = appointmentReminder;
      _appointmentConfirmed = appointmentConfirmed;
      _appointmentCancelled = appointmentCancelled;
      _labResult = labResult;
      _reminderMinutes = reminderMinutes;
      _darkMode = SettingsManager.isDarkMode;
    });
  }

  Future<void> _setAppointmentReminder(bool value) async {
    await _settings.setBool(
      NotificationSettingsService.keyAppointmentReminder,
      value,
    );

    setState(() => _appointmentReminder = value);

    _showMessage(value ? 'Đã bật nhắc lịch khám' : 'Đã tắt nhắc lịch khám');
  }

  Future<void> _setAppointmentConfirmed(bool value) async {
    await _settings.setBool(
      NotificationSettingsService.keyAppointmentConfirmed,
      value,
    );

    setState(() => _appointmentConfirmed = value);

    _showMessage(
      value
          ? 'Đã bật thông báo xác nhận lịch'
          : 'Đã tắt thông báo xác nhận lịch',
    );
  }

  Future<void> _setAppointmentCancelled(bool value) async {
    await _settings.setBool(
      NotificationSettingsService.keyAppointmentCancelled,
      value,
    );

    setState(() => _appointmentCancelled = value);

    _showMessage(
      value ? 'Đã bật thông báo hủy lịch' : 'Đã tắt thông báo hủy lịch',
    );
  }

  Future<void> _setLabResult(bool value) async {
    await _settings.setBool(NotificationSettingsService.keyLabResult, value);

    setState(() => _labResult = value);

    _showMessage(
      value
          ? 'Đã bật thông báo kết quả xét nghiệm'
          : 'Đã tắt thông báo kết quả xét nghiệm',
    );
  }

  Future<void> _selectReminderMinutes() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Chọn thời gian nhắc trước',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _reminderOption(15),
              _reminderOption(30),
              _reminderOption(60),
              _reminderOption(120),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (selected == null) return;

    await _settings.setReminderMinutes(selected);

    if (!mounted) return;

    setState(() => _reminderMinutes = selected);

    _showMessage('Đã đặt nhắc trước $selected phút');
  }

  Widget _reminderOption(int minutes) {
    return ListTile(
      title: Text('$minutes phút'),
      trailing: _reminderMinutes == minutes
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () => Navigator.pop(context, minutes),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }

  Widget _normalTile({
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 6),
          if (onTap != null) const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  void _selectLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                AppTranslations.tr('language'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Tiếng Việt'),
                trailing: SettingsManager.currentLanguage == 'vi'
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, 'vi'),
              ),
              ListTile(
                title: const Text('English'),
                trailing: SettingsManager.currentLanguage == 'en'
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(context, 'en'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (selected == null) return;
    await SettingsManager.setLanguage(selected);
    setState(() {});
    _showMessage(
      selected == 'vi'
          ? 'Đã chuyển sang Tiếng Việt'
          : 'Switched to English',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: SettingsManager.themeMode,
          builder: (context, mode, _) {
            final isDark = mode == ThemeMode.dark ||
                (mode == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness == Brightness.dark);
            final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7F8);
            final appBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
            final textColor = isDark ? Colors.white : Colors.black87;

            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                title: Text(AppTranslations.tr('settings')),
                centerTitle: true,
                backgroundColor: appBgColor,
                foregroundColor: textColor,
                elevation: 0,
              ),
              body: ListView(
                children: [
                  _sectionTitle(AppTranslations.tr('notifications_header')),
                  _card(
                    isDark: isDark,
                    children: [
                      _switchTile(
                        icon: Icons.alarm,
                        title: AppTranslations.tr('reminders'),
                        value: _appointmentReminder,
                        onChanged: _setAppointmentReminder,
                      ),
                      _normalTile(
                        icon: Icons.timer,
                        title: AppTranslations.tr('remind_before'),
                        trailingText: '$_reminderMinutes min',
                        onTap: _selectReminderMinutes,
                      ),
                      _switchTile(
                        icon: Icons.check_circle_outline,
                        title: AppTranslations.tr('booking_confirmed'),
                        value: _appointmentConfirmed,
                        onChanged: _setAppointmentConfirmed,
                      ),
                      _switchTile(
                        icon: Icons.cancel_outlined,
                        title: AppTranslations.tr('cancel_alerts'),
                        value: _appointmentCancelled,
                        onChanged: _setAppointmentCancelled,
                      ),
                      _switchTile(
                        icon: Icons.assignment_outlined,
                        title: AppTranslations.tr('test_results'),
                        value: _labResult,
                        onChanged: _setLabResult,
                      ),
                    ],
                  ),

                  _sectionTitle(AppTranslations.tr('system_header')),
                  _card(
                    isDark: isDark,
                    children: [
                      _normalTile(
                        icon: Icons.language,
                        title: AppTranslations.tr('language'),
                        trailingText: SettingsManager.currentLanguage == 'vi'
                            ? 'Tiếng Việt'
                            : 'English',
                        onTap: _selectLanguage,
                      ),
                      SwitchListTile(
                        secondary: const Icon(
                          Icons.dark_mode,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          AppTranslations.tr('dark_mode'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: _darkMode,
                        activeColor: AppColors.primary,
                        onChanged: (value) async {
                          setState(() => _darkMode = value);
                          await SettingsManager.toggleTheme(value);
                          _showMessage(
                            value ? 'Đã bật chế độ tối' : 'Đã tắt chế độ tối',
                          );
                        },
                      ),
                      _normalTile(
                        icon: Icons.menu_book,
                        title: AppTranslations.tr('user_guide'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserGuideScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  _sectionTitle(AppTranslations.tr('security_header')),
                  _card(
                    isDark: isDark,
                    children: [
                      _normalTile(
                        icon: Icons.lock_outline,
                        title: AppTranslations.tr('change_password'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      '${AppTranslations.tr('version')} 1.0.0',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

