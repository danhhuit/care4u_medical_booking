import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/app/router/route_names.dart';
import 'package:care4u_medical_booking/app/theme/app_colors.dart';
import 'package:care4u_medical_booking/shared/mock/mock_data.dart';
import 'package:care4u_medical_booking/features/store/presentation/screens/product_list_screen.dart';
import 'package:care4u_medical_booking/features/doctors/screens/doctors_screen.dart';
import 'package:care4u_medical_booking/features/specialties/screens/specialties_screen.dart';
import 'package:care4u_medical_booking/features/notifications/presentation/screens/notification_list_screen.dart';
import 'package:care4u_medical_booking/features/chat/presentation/screens/chatbot_screen.dart';

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
    const Color turquoiseBg = Color(0xFFA1E4D5);
    final patient = MockData.currentPatient;

    return Scaffold(
      backgroundColor: turquoiseBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, patient),
                const SizedBox(height: 24),
                _buildSearchBar(context),
                const SizedBox(height: 24),
                _buildQuickActionsSlider(context),
                const SizedBox(height: 24),
                _buildHealthProducts(context),
                const SizedBox(height: 24),
                _buildFeaturedServices(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> patient) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting only — no logo, no notification in top bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xin chào,',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              patient['name']!.split(' ').last,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Notification bell with badge
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationListScreen()),
              ),
              child: Stack(
                children: [
                  _iconBtn(Icons.notifications_none),
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
                                fontWeight: FontWeight.bold),
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
              child: _iconBtn(Icons.chat_bubble_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.blue),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DoctorsScreen()),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm bác sĩ, chuyên khoa...',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSlider(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
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
                // Page 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionItem(Icons.person, 'Tìm bác sĩ\nriêng', Colors.blue,
                        Colors.blue.withOpacity(0.1), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const DoctorsScreen()));
                    }),
                    _actionItem(Icons.shopping_cart_outlined, 'Mua thuốc',
                        Colors.blue, Colors.blue.withOpacity(0.1), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ProductListScreen()));
                    }),
                    _actionItem(Icons.local_hospital, 'Chuyên\nkhoa',
                        Colors.blue, Colors.blue.withOpacity(0.1), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SpecialtiesScreen()));
                    }),
                  ],
                ),
                // Page 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionItem(
                        Icons.folder_special,
                        'Sổ tiêm\nchủng',
                        const Color(0xFF5C6BC0),
                        const Color(0xFFE2E9FE),
                        () {}),
                    _actionItem(
                        Icons.assignment,
                        'Hồ sơ\nsức khoẻ',
                        const Color(0xFF5C6BC0),
                        const Color(0xFFE2E9FE), () {
                      Navigator.pushNamed(context, RouteNames.medicalRecordList);
                    }),
                    _actionItem(
                        Icons.calendar_month,
                        'Đặt lịch\nkhám',
                        const Color(0xFF5C6BC0),
                        const Color(0xFFE2E9FE), () {
                      Navigator.pushNamed(context, RouteNames.appointmentList);
                    }),
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
                      ? const Color(0xFF5B6CCC)
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

  Widget _actionItem(IconData icon, String label, Color iconColor,
      Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: bgColor,
              radius: 26,
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthProducts(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sản phẩm sức khỏe',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProductListScreen())),
                child: const Row(
                  children: [
                    Text('Xem tất cả',
                        style: TextStyle(color: Colors.blue, fontSize: 13)),
                    Icon(Icons.arrow_forward, color: Colors.blue, size: 16),
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
              _productCategoryItem(Icons.local_fire_department, Colors.orange,
                  'Bán chạy', Colors.red.withOpacity(0.1)),
              _productCategoryItem(Icons.clean_hands, Colors.blue,
                  'Chăm sóc\nrăng miệng', Colors.blue.withOpacity(0.1)),
              _productCategoryItem(Icons.medication_liquid, Colors.indigo,
                  'Thực phẩm\nchức năng', Colors.indigo.withOpacity(0.1)),
              _productCategoryItem(
                  Icons.medication, Colors.blue, 'Thuốc', Colors.blue.withOpacity(0.1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCategoryItem(
      IconData icon, Color iconColor, String label, Color bg) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFeaturedServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Dịch vụ nổi bật',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            SizedBox(width: 30, child: Divider(color: Colors.blue, thickness: 2)),
            SizedBox(width: 10, child: Divider(color: Colors.grey, thickness: 2)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _serviceCard('Chăm sóc tại nhà', 'assests/images/bacsi_1.jpg'),
              const SizedBox(width: 16),
              _serviceCard('Xét nghiệm tại nhà', 'assests/images/default_doctor.jpg'),
              const SizedBox(width: 16),
              _serviceCard('Tư vấn tâm lý', 'assests/images/logo.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _serviceCard(String title, String imagePath) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
