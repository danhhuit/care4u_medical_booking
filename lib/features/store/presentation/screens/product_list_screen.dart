import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _selectedCategory = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Tất cả', 'icon': Icons.apps},
    {'label': 'Bán chạy', 'icon': Icons.local_fire_department},
    {'label': 'Chăm sóc\nrăng miệng', 'icon': Icons.sentiment_satisfied_alt},
    {'label': 'Thực phẩm\nchức năng', 'icon': Icons.eco},
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Lactacyd milky vỏ 500ml Milky',
      'price': 190000,
      'originalPrice': null,
      'isHot': true,
      'discount': null,
      'category': 1,
    },
    {
      'name': 'Sorbitol Salalende - Gói',
      'price': 2200,
      'originalPrice': null,
      'isHot': true,
      'discount': null,
      'category': 1,
    },
    {
      'name': 'Prospan 100ml Chai',
      'price': 190000,
      'originalPrice': null,
      'isHot': true,
      'discount': null,
      'category': 2,
    },
    {
      'name': 'Serum dưỡng ẩm da, kẽ...',
      'price': 190000,
      'originalPrice': null,
      'isHot': true,
      'discount': null,
      'category': 3,
    },
    {
      'name': 'Serum dưỡng ẩm da, kẽ...',
      'price': 75000,
      'originalPrice': 150000,
      'isHot': false,
      'discount': '50%',
      'category': 2,
    },
    {
      'name': 'Hạt huyết dưỡng não...',
      'price': 75000,
      'originalPrice': 150000,
      'isHot': false,
      'discount': '50%',
      'category': 3,
    },
    {
      'name': 'Sanlinin 0.1% - lọ',
      'price': 190000,
      'originalPrice': null,
      'isHot': false,
      'discount': null,
      'category': 2,
    },
    {
      'name': 'Refresh Tears 15 ml Hộp',
      'price': 190000,
      'originalPrice': null,
      'isHot': false,
      'discount': null,
      'category': 3,
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 0) return _allProducts;
    return _allProducts
        .where((p) => p['category'] == _selectedCategory)
        .toList();
  }

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$formatted đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Danh mục sp',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Nhập sản phẩm cần tìm',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Category tabs
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFA1E4D5)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          color: isSelected
                              ? const Color(0xFF2BB5A0)
                              : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? const Color(0xFF2BB5A0)
                                : Colors.grey[600],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Product grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image placeholder
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Icon(
                    Icons.medication,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),

              // Product info
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (product['originalPrice'] != null)
                      Text(
                        _formatPrice(product['originalPrice'] as int),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      _formatPrice(product['price'] as int),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // HOT badge
          if (product['isHot'] == true)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'HOT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Discount badge
          if (product['discount'] != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  product['discount'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
