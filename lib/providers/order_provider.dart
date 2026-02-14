import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart';

class OrderProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  void addOrder(List<Food> items, double total) {
    _orders.insert(0, {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "date": DateTime.now().toString().substring(0, 16),
      "total": total,
      "items": items.map((f) => {
        "name": f.name,
        "price": f.price,
        "qty": 1,
      }).toList(),
    });

    notifyListeners();
  }
}
