import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = true;
  bool _confirmNotif = true;
  bool _cancelNotif = true;
  bool _resultNotif = true;
  int _reminderMinutes = 60;

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.tr('language'),
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 16),
            _langOption('Tiếng Việt', 'vi', '🇻🇳'),
            const Divider(),
            _langOption('English', 'en', '🇬🇧'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _langOption(String label, String code, String flag) {
    final selected = SettingsManager.currentLanguage == code;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(label, style: AppTextStyles.bodyDark),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () {
        // Pop the language picker first to avoid navigation conflicts during rebuild
        Navigator.pop(context);
        // Then trigger the global update
        SettingsManager.setLanguage(code);
      },
    );
  }

  void _showReminderPicker() {
    final options = [15, 30, 60, 120, 1440];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.tr('remind_before'),
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 12),
            ...options.map((m) {
              String label = m < 60 ? '$m min' : '${m ~/ 60} hour';
              return ListTile(
                title: Text(label, style: AppTextStyles.bodyDark),
                trailing: _reminderMinutes == m
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _reminderMinutes = m);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppTranslations.tr('change_password'),
          style: AppTextStyles.heading2,
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             TextField(decoration: InputDecoration(labelText: 'Old Password')),
             SizedBox(height: 12),
             TextField(decoration: InputDecoration(labelText: 'New Password')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppTranslations.tr('cancelled'), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTranslations.tr('share_feedback'), style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            const TextField(maxLines: 3),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.tr('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGroup(AppTranslations.tr('notifications_header'), [
            _buildSwitchItem(Icons.alarm, AppTranslations.tr('reminders'), _reminderEnabled, (v) => setState(() => _reminderEnabled = v)),
            if (_reminderEnabled) 
              _buildSettingItem(Icons.timer_outlined, AppTranslations.tr('remind_before'), _showReminderPicker, trailing: '$_reminderMinutes min'),
            _buildSwitchItem(Icons.check_circle_outline, AppTranslations.tr('booking_confirmed'), _confirmNotif, (v) => setState(() => _confirmNotif = v)),
            _buildSwitchItem(Icons.cancel_outlined, AppTranslations.tr('cancel_alerts'), _cancelNotif, (v) => setState(() => _cancelNotif = v)),
            _buildSwitchItem(Icons.assignment_outlined, AppTranslations.tr('test_results'), _resultNotif, (v) => setState(() => _resultNotif = v)),
          ]),
          const SizedBox(height: 20),
          _buildGroup(AppTranslations.tr('system_header'), [
            _buildSettingItem(Icons.language, AppTranslations.tr('language'), _showLanguagePicker, trailing: SettingsManager.currentLanguage == 'vi' ? 'Tiếng Việt' : 'English'),
            _buildSwitchItem(
              Icons.dark_mode, 
              AppTranslations.tr('dark_mode'), 
              SettingsManager.isDarkMode, 
              (v) {
                // Brief delay or direct call is fine now that Care4uApp uses GlobalKey
                SettingsManager.toggleTheme(v);
                if (mounted) setState(() {});
              }
            ),
            _buildSettingItem(Icons.menu_book_outlined, AppTranslations.tr('user_guide'), () {}),
          ]),
          const SizedBox(height: 20),
          _buildGroup(AppTranslations.tr('reviews_feedback'), [
            _buildSettingItem(Icons.star_rate_outlined, AppTranslations.tr('rate_doctor'), () => Navigator.pushNamed(context, RouteNames.reviewDoctor)),
            _buildSettingItem(Icons.feedback_outlined, AppTranslations.tr('share_feedback'), _showFeedbackDialog),
          ]),
          const SizedBox(height: 20),
          _buildGroup(AppTranslations.tr('security_header'), [
            _buildSettingItem(Icons.lock_outline, AppTranslations.tr('change_password'), _showChangePasswordDialog),
          ]),
          const SizedBox(height: 24),
          Center(child: Text('${AppTranslations.tr('version')} 1.0.0', style: AppTextStyles.captionLight)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(title, style: AppTextStyles.heading2),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap, {String? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyDark),
      trailing: trailing != null ? Text(trailing, style: AppTextStyles.captionLight) : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyDark),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
