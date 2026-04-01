import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/features/store/presentation/screens/product_list_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctors_screen.dart';
import 'package:care4u_medical_booking/features/specialties/screens/specialties_screen.dart';
import 'package:care4u_medical_booking/features/notifications/presentation/screens/notification_list_screen.dart';
import 'package:care4u_medical_booking/features/chat/presentation/screens/chatbot_screen.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentQuickActionPage = 0;

  int get _unreadCount =>
      MockData.notifications.where((n) => n['isRead'] == false).length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patient = MockData.currentPatient;
    final turquoiseBg = isDark ? Colors.black : const Color(0xFFA1E4D5);

    return Scaffold(
      backgroundColor: turquoiseBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, patient, isDark),
                const SizedBox(height: 24),
                _buildSearchBar(context, isDark),
                const SizedBox(height: 24),
                _buildQuickActionsSlider(context, isDark),
                const SizedBox(height: 24),
                _buildHealthProducts(context, isDark),
                const SizedBox(height: 24),
                _buildFeaturedServices(isDark),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Map<String, dynamic> patient,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.tr('welcome'),
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 13,
              ),
            ),
            Text(
              patient['name']!.split(' ').last,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationListScreen(),
                ),
              ),
              child: Stack(
                children: [
                  _iconBtn(Icons.notifications_none, isDark),
                  if (_unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatBotScreen()),
              ),
              child: _iconBtn(Icons.chat_bubble_outline, isDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon, bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: isDark ? Colors.white : AppColors.primary),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DoctorsScreen()),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
              hintText: AppTranslations.tr('search_doctor_hint'),
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSlider(BuildContext context, bool isDark) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) =>
                  setState(() => _currentQuickActionPage = index),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionItem(
                      Icons.person,
                      AppTranslations.tr('quick_find_doctor'),
                      Colors.blue,
                      Colors.blue.withValues(alpha: 0.1),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DoctorsScreen(),
                        ),
                      ),
                      isDark,
                    ),
                    _actionItem(
                      Icons.shopping_cart_outlined,
                      AppTranslations.tr('buy_meds'),
                      Colors.blue,
                      Colors.blue.withValues(alpha: 0.1),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductListScreen(),
                        ),
                      ),
                      isDark,
                    ),
                    _actionItem(
                      Icons.local_hospital,
                      AppTranslations.tr('specialties'),
                      Colors.blue,
                      Colors.blue.withValues(alpha: 0.1),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SpecialtiesScreen(),
                        ),
                      ),
                      isDark,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionItem(
                      Icons.folder_special,
                      'Sổ tiêm',
                      const Color(0xFF5C6BC0),
                      const Color(0xFFE2E9FE),
                      () {},
                      isDark,
                    ),
                    _actionItem(
                      Icons.assignment,
                      AppTranslations.tr('health_profile'),
                      const Color(0xFF5C6BC0),
                      const Color(0xFFE2E9FE),
                      () => Navigator.pushNamed(
                        context,
                        RouteNames.medicalRecordList,
                      ),
                      isDark,
                    ),
                    _actionItem(
                      Icons.calendar_month,
                      AppTranslations.tr('book_now'),
                      const Color(0xFF5C6BC0),
                      const Color(0xFFE2E9FE),
                      () => Navigator.pushNamed(
                        context,
                        RouteNames.appointmentList,
                      ),
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
                width: _currentQuickActionPage == index ? 20 : 8,
                height: 5,
                decoration: BoxDecoration(
                  color: _currentQuickActionPage == index
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _actionItem(
    IconData icon,
    String label,
    Color iconColor,
    Color bgColor,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : bgColor,
              radius: 26,
              child: Icon(
                icon,
                color: isDark ? Colors.white : iconColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthProducts(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTranslations.tr('health_products'),
                style: AppTextStyles.heading2,
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListScreen()),
                ),
                child: Row(
                  children: [
                    Text(
                      AppTranslations.tr('see_all'),
                      style: const TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productCategoryItem(
                Icons.local_fire_department,
                Colors.orange,
                AppTranslations.tr('best_seller'),
                isDark,
              ),
              _productCategoryItem(
                Icons.clean_hands,
                Colors.blue,
                AppTranslations.tr('dental_care'),
                isDark,
              ),
              _productCategoryItem(
                Icons.medication_liquid,
                Colors.indigo,
                AppTranslations.tr('supplements'),
                isDark,
              ),
              _productCategoryItem(
                Icons.medication,
                Colors.blue,
                AppTranslations.tr('medication'),
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCategoryItem(
    IconData icon,
    Color iconColor,
    String label,
    bool isDark,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white : iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedServices(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTranslations.tr('featured_services'),
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _serviceItem(
                'Chăm sóc tại nhà',
                'assests/images/bacsi_1.jpg',
                isDark,
              ),
              const SizedBox(width: 16),
              _serviceItem(
                'Xét nghiệm',
                'assests/images/default_doctor.jpg',
                isDark,
              ),
              const SizedBox(width: 16),
              _serviceItem('Tư vấn tâm lý', 'assests/images/logo.png', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _serviceItem(String title, String imagePath, bool isDark) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.grey.shade300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// lâu lâu tự reset làm sao đây??:<
