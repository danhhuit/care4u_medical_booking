import 'package:flutter/material.dart';

import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/app/theme/app_text_styles.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/features/chat/presentation/screens/patient_chat_rooms_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctors_screen.dart';
import 'package:care4u_medical_booking/features/notifications/presentation/screens/notification_list_screen.dart';
import 'package:care4u_medical_booking/features/specialties/screens/specialties_screen.dart';
import 'package:care4u_medical_booking/features/store/presentation/screens/product_list_screen.dart';
import 'package:care4u_medical_booking/features/store/presentation/screens/wallet_screen.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  final Care4UApiService _api = Care4UApiService();

  int _currentQuickActionPage = 0;

  String _patientName = 'Người dùng';

  int get _unreadCount =>
      MockData.notifications.where((n) => n['isRead'] == false).length;

  String get _shortName {
    final name = _patientName.trim();
    if (name.isEmpty) return 'Bạn';

    final parts = name.split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.last : name;
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentPatient();
  }

  Future<void> _loadCurrentPatient() async {
    try {
      final patientId = SettingsManager.currentPatientId;
      final patient = await _api.getPatientById(patientId);

      if (!mounted) return;

      setState(() {
        _patientName = '${patient['fullName'] ?? 'Người dùng'}'.trim();
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _patientName = 'Người dùng';
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsManager.languageCode,
      builder: (context, lang, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final turquoiseBg = isDark ? Colors.black : const Color(0xFFA1E4D5);

        return Container(
          color: turquoiseBg,
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadCurrentPatient,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, isDark),
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
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                onPressed: () {
                  _loadCurrentPatient();
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
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
                  _shortName,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              ),
              child: _iconBtn(Icons.account_balance_wallet, isDark),
            ),
            const SizedBox(width: 12),
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
                MaterialPageRoute(
                  builder: (_) => const PatientChatRoomsScreen(),
                ),
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
                      Icons.calendar_today_outlined,
                      AppTranslations.tr('nav_appointments'),
                      const Color(0xFF5C6BC0),
                      const Color(0xFFE2E9FE),
                      () => Navigator.pushNamed(
                        context,
                        RouteNames.appointmentList,
                      ),
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
                      () => Navigator.pushNamed(context, RouteNames.mapBooking),
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
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentQuickActionPage == index ? 20 : 8,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _currentQuickActionPage == index
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
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
    final hotProducts = MockData.products
        .where((p) => p['isHot'] == true)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sản phẩm nổi bật', style: AppTextStyles.heading2),
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
                  const Icon(Icons.arrow_forward, color: Colors.blue, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hotProducts.length,
            itemBuilder: (context, index) {
              final product = hotProducts[index];

              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2C2C2C)
                              : Colors.grey[100],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Icon(
                          Icons.medication,
                          size: 50,
                          color: isDark ? Colors.grey[600] : Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product['name'] ?? ''}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(product['price'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} đ',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
