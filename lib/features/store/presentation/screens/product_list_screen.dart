import 'package:flutter/material.dart';
import 'package:care4u_medical_booking/core/api/care4u_api_service.dart';
import 'package:care4u_medical_booking/core/constants/app_translations.dart';
import 'package:care4u_medical_booking/app/theme/settings_manager.dart';
import 'package:care4u_medical_booking/core/services/cart_service.dart';
import 'package:care4u_medical_booking/features/store/presentation/screens/cart_screen.dart';
import 'order_history_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final Care4UApiService _api = Care4UApiService();

  int _selectedCategory = 0;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _allProducts = [];

  List<Map<String, dynamic>> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();

    return _allProducts.where((product) {
      final name = '${product['name'] ?? ''}'.toLowerCase();
      final brand = '${product['brand'] ?? ''}'.toLowerCase();
      final description = '${product['description'] ?? ''}'.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          name.contains(query) ||
          brand.contains(query) ||
          description.contains(query);

      final categoryId = int.tryParse('${product['categoryId'] ?? 0}') ?? 0;
      final matchesCategory =
          _selectedCategory == 0 || categoryId == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await _api.getStoreProducts();

      if (!mounted) return;

      setState(() {
        _allProducts = products.map(_normalizeProduct).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể tải sản phẩm: $e';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _normalizeProduct(Map<String, dynamic> product) {
    final price = _toDouble(product['price']);
    final salePrice = product['salePrice'] == null
        ? null
        : _toDouble(product['salePrice']);
    final displayPrice = salePrice ?? price;

    return {
      ...product,
      // CartService hiện tại đang dùng product['price'], nên price ở đây là giá bán thực tế.
      // Đưa về int để CartService/CartScreen cũ không lỗi kiểu double -> int.
      'price': displayPrice.round(),
      'originalPrice': salePrice == null ? null : price.round(),
      'discount': salePrice == null ? null : _discountText(price, salePrice),
      'isHot':
          (int.tryParse('${product['totalSold'] ?? 0}') ?? 0) > 0 ||
          (double.tryParse('${product['rating'] ?? 0}') ?? 0) >= 4.5,
    };
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  String? _discountText(double original, double sale) {
    if (original <= 0 || sale <= 0 || sale >= original) return null;
    final percent = ((original - sale) / original * 100).round();
    return '-$percent%';
  }

  String _formatPrice(dynamic price) {
    final value = _toDouble(price).round();
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$formatted đ';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsManager.themeMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: SettingsManager.languageCode,
          builder: (context, lang, _) {
            final categories = [
              {'label': AppTranslations.tr('all_products'), 'icon': Icons.apps},
              {'label': 'Thiết bị', 'icon': Icons.health_and_safety},
              {'label': 'Thuốc', 'icon': Icons.medication},
              {'label': 'Chăm sóc', 'icon': Icons.spa},
            ];

            final isDark =
                mode == ThemeMode.dark ||
                (mode == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark);
            final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
            final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
            final textColor = isDark ? Colors.white : Colors.black;

            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                backgroundColor: cardColor,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  AppTranslations.tr('product_category'),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.receipt_long, color: textColor),
                    tooltip: 'Lịch sử đơn hàng',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: textColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CartScreen(),
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<List<CartItem>>(
                        valueListenable: CartService.instance.items,
                        builder: (context, items, _) {
                          final count = CartService.instance.totalItemsCount;
                          if (count == 0) return const SizedBox.shrink();
                          return Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2C2C2C)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: AppTranslations.tr('search_product_hint'),
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = _selectedCategory == index;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(
                                      0xFFA1E4D5,
                                    ).withValues(alpha: isDark ? 0.2 : 1.0)
                                  : (isDark
                                        ? const Color(0xFF2C2C2C)
                                        : Colors.grey[100]),
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
                  Expanded(child: _buildBody(isDark, cardColor, textColor)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(bool isDark, Color cardColor, Color textColor) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final products = _filteredProducts;

    if (products.isEmpty) {
      return const Center(child: Text('Không tìm thấy sản phẩm phù hợp'));
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductCard(product, isDark, cardColor, textColor);
        },
      ),
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product,
    bool isDark,
    Color cardColor,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () {
        _showProductBottomSheet(context, product, isDark, cardColor, textColor);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.15),
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2C2C2C)
                          : Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: buildProductImage(
                      product,
                      isDark: isDark,
                      height: 140,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withValues(alpha: 0.87),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (product['originalPrice'] != null)
                        Text(
                          _formatPrice(product['originalPrice']),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatPrice(product['price']),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (product['isHot'] == true && product['discount'] == null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
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
            if (product['discount'] != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
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
      ),
    );
  }

  void _showProductBottomSheet(
    BuildContext context,
    Map<String, dynamic> product,
    bool isDark,
    Color cardColor,
    Color textColor,
  ) {
    int quantity = 1;
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final description = product['description']?.toString();

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2C2C2C)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: buildProductImage(
                          product,
                          isDark: isDark,
                          height: 80,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatPrice(product['price']),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            if (product['brand'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Thương hiệu: ${product['brand']}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Số lượng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.grey,
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                          ),
                          Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Colors.blue,
                            onPressed: () {
                              final stockQuantity =
                                  int.tryParse(
                                    '${product['stockQuantity'] ?? 9999}',
                                  ) ??
                                  9999;
                              if (quantity < stockQuantity) {
                                setState(() => quantity++);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        CartService.instance.addToCart(
                          product,
                          quantity: quantity,
                        );
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đã thêm $quantity sản phẩm vào giỏ hàng',
                            ),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'XEM GIỎ HÀNG',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CartScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildProductImage(
    Map<String, dynamic> product, {
    required bool isDark,
    double height = 120,
    BorderRadius? borderRadius,
  }) {
    final imageUrl =
        '${product['imageUrl'] ?? product['image_url'] ?? product['thumbnailUrl'] ?? ''}'
            .trim();

    final placeholder = Container(
      height: height,
      width: double.infinity,
      color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
      child: Icon(
        Icons.medication,
        size: height >= 100 ? 52 : 38,
        color: isDark ? Colors.grey[600] : Colors.grey,
      ),
    );

    if (imageUrl.isNotEmpty && imageUrl != 'null') {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: placeholder,
    );
  }

  Widget _productPlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: const Icon(Icons.medication, size: 52, color: Colors.grey),
    );
  }
}
