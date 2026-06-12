import 'package:flutter/foundation.dart';

class CartItem {
  final Map<String, dynamic> product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => (product['price'] as int) * quantity.toDouble();
}

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
    final index = items.value.indexWhere((item) => item.product['name'] == product['name']);
    if (index >= 0) {
      items.value[index].quantity += quantity;
    } else {
      items.value.add(CartItem(product: product, quantity: quantity));
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    items.notifyListeners();
  }

  void removeFromCart(String productName) {
    items.value.removeWhere((item) => item.product['name'] == productName);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    items.notifyListeners();
  }

  void updateQuantity(String productName, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productName);
      return;
    }
    final index = items.value.indexWhere((item) => item.product['name'] == productName);
    if (index >= 0) {
      items.value[index].quantity = quantity;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      items.notifyListeners();
    }
  }

  void clearCart() {
    items.value.clear();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    items.notifyListeners();
  }

  double get totalAmount {
    return items.value.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemsCount {
    return items.value.fold(0, (sum, item) => sum + item.quantity);
  }
}
