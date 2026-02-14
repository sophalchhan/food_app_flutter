import 'package:flutter/material.dart';
import 'package:food_app/models/cart_item.dart';
import 'package:food_app/models/food.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // 🔢 Total items (for badge)
  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  // 💰 Total price
  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.food.price * item.quantity);

  // ➕ Add to cart
  void addToCart(Food food) {
    final index = _items.indexWhere(
      (item) => item.food.name == food.name,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(food: food));
    }
    notifyListeners();
  }

  // ➕ Increase
  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  // ➖ Decrease
  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
