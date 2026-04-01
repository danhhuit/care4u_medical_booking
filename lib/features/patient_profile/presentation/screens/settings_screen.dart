import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Cài đặt'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGroup(
            'Hệ thống',
            [
              _buildSettingItem(Icons.menu_book, 'Hướng dẫn sử dụng', () {}),
              _buildSettingItem(Icons.language, 'Thiết lập ngôn ngữ', () {}, trailing: 'Tiếng Việt'),
              _buildSettingItem(Icons.dark_mode, 'Chế độ (Sáng/ tối)', () {}, trailingWidget: Switch(value: false, onChanged: (v){}, activeColor: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 24),
          _buildGroup(
            'Bảo mật',
            [
              _buildSettingItem(Icons.lock_outline, 'Đổi mật khẩu', () {}),
            ],
          ),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            children: items.map((e) => Column(
              children: [
                e,
                if (e != items.last) const Divider(height: 1, indent: 56),
              ],
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap, {String? trailing, Widget? trailingWidget}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyDark),
      trailing: trailingWidget ?? (trailing != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(trailing, style: AppTextStyles.captionLight),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            )
          : const Icon(Icons.chevron_right, color: Colors.grey)),
      onTap: onTap,
    );
  }
}
