import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = MockData.adminUsers;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final u = users[i];
          final isDoctor = u['role'] == 'doctor';
          final isActive = u['isActive'] as bool;
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isDoctor ? AppColors.primary.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                  child: Icon(
                    isDoctor ? Icons.medical_services : Icons.person,
                    color: isDoctor ? AppColors.primary : Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u['name']!, style: AppTextStyles.bodyDark),
                      Text(u['email']!, style: AppTextStyles.captionLight),
                      const SizedBox(height: 2),
                      Text(
                        isDoctor ? 'Bác sĩ' : 'Bệnh nhân',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDoctor ? AppColors.primary : Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.success.withOpacity(0.12)
                        : Colors.grey.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Hoạt động' : 'Bị khoá',
                    style: TextStyle(
                      color: isActive ? AppColors.success : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
