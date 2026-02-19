import 'package:flutter/material.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/models/food.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(List<Food> items, double total, {String status = "Pending"}) {
    _orders.insert(0, Order(items: items, total: total, status: status));
    notifyListeners();
  }

  void updateOrderStatus(int index, String status) {
    _orders[index].status = status;
    notifyListeners();
  }
}
