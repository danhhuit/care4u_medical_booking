import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/features/store/presentation/screens/product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentQuickActionPage = 0;

  @override
  Widget build(BuildContext context) {
    // Light turquoise background from the design
    const Color turquoiseBg = Color(0xFFA1E4D5);

    return Scaffold(
      backgroundColor: turquoiseBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildQuickActionsSlider(),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo Care4U circle
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assests/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.favorite, color: Colors.blue),
            ),
          ),
        ),
        Row(
          children: [
            _buildIconBtn(Icons.notifications_none),
            const SizedBox(width: 12),
            _buildIconBtn(Icons.chat_bubble_outline),
          ],
        ),
      ],
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.blue),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Da liễu',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSlider() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentQuickActionPage = index;
                });
              },
              children: [
                // Page 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionItem(
                      Icons.person,
                      'Tìm bác sĩ\nriêng',
                      Colors.blue,
                      Colors.blue.withOpacity(0.1),
                    ),
                    _buildActionItem(
                      Icons.shopping_cart_outlined,
                      'Mua thuốc',
                      Colors.blue,
                      Colors.blue.withOpacity(0.1),
                    ),
                    _buildActionItem(
                      Icons.support_agent,
                      'Tư vấn\nngay',
                      Colors.blue,
                      Colors.blue.withOpacity(0.1),
                    ),
                  ],
                ),
                // Page 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionItem(
                      Icons.folder_special,
                      'Sổ tiêm\nchủng',
                      const Color(0xFF5C6BC0),
                      const Color(0xFFE2E9FE),
                    ),
                    _buildActionItem(
                      Icons.assignment,
                      'Hồ sơ\nsức khoẻ',
                      const Color(0xFF5C6BC0),
                      const Color(0xFFE2E9FE),
                    ),
                    _buildActionItem(
                      Icons.local_hospital,
                      'Đặt lịch\nkhám',
                      const Color(0xFF5C6BC0),
                      const Color(0xFFE2E9FE),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Indicators
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  left: _currentQuickActionPage == 0 ? 0 : 20,
                  child: Container(
                    width: 20,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B6CCC),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    Color iconColor,
    Color bgColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 26,
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthProducts(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sản phẩm sức khỏe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductListScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Xem tất cả',
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
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
              _buildProductCategoryItem(
                Icons.local_fire_department,
                Colors.orange,
                'Bán chạy',
                Colors.red.withOpacity(0.1),
              ),
              _buildProductCategoryItem(
                Icons.clean_hands,
                Colors.blue,
                'Chăm sóc\nrăng miệng',
                Colors.blue.withOpacity(0.1),
              ),
              _buildProductCategoryItem(
                Icons.medication_liquid,
                Colors.indigo,
                'Thực phẩm\nchức năng',
                Colors.indigo.withOpacity(0.1),
              ),
              _buildProductCategoryItem(
                Icons.medication,
                Colors.blue,
                'Thuốc',
                Colors.blue.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCategoryItem(
    IconData icon,
    Color iconColor,
    String label,
    Color bg,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
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
            Text(
              'Dịch vụ nổi bật',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            // Dummy dotted line similar to design image next to standard title
            SizedBox(
              width: 30,
              child: Divider(color: Colors.blue, thickness: 2),
            ),
            SizedBox(
              width: 10,
              child: Divider(color: Colors.grey, thickness: 2),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildServiceCard(
                'Chăm sóc tại nhà',
                'assests/images/bacsi_1.jpg',
              ),
              const SizedBox(width: 16),
              _buildServiceCard(
                'Xét nghiệm tại nhà',
                'assests/images/default_doctor.jpg',
              ),
              const SizedBox(width: 16),
              // More placeholders just in case
              _buildServiceCard('Tư vấn tâm lý', 'assests/images/logo.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, String imagePath) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
