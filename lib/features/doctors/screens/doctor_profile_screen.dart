import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'doctor_main_screen.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorSession.currentDoctor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2BB5A0), Color(0xFF1A7A6E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: Text(
                          doctor['name'].toString().split(' ').last.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        doctor['name']!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        doctor['specialty']!,
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thông tin hành nghề', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  _infoCard([
                    _row(Icons.badge, 'Mã định danh', doctor['licenseId']!),
                    _div(),
                    _row(Icons.local_hospital, 'Bệnh viện', doctor['hospital']!),
                    _div(),
                    _row(Icons.work, 'Kinh nghiệm', doctor['experience']!),
                    _div(),
                    _row(Icons.star, 'Đánh giá TB',
                        '${doctor['rating']} (${doctor['reviews']} đánh giá)'),
                  ]),
                  const SizedBox(height: 20),
                  Text('Liên hệ', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  _infoCard([
                    _row(Icons.phone, 'Điện thoại', doctor['phone']!),
                    _div(),
                    _row(Icons.email, 'Email', doctor['email']!),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, RouteNames.login);
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Đăng xuất',
                          style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Column(children: children),
      );

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: AppTextStyles.captionLight),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyDark),
            ]),
          ),
        ]),
      );

  Widget _div() => const Divider(height: 1, indent: 48);
}
