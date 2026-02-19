import 'package:food_app/models/food.dart';

class Order {
  final List<Food> items;
  final double total;
  String status;
  final DateTime date;

  Order({
    required this.items,
    required this.total,
    this.status = "Pending",
    DateTime? date,
  }) : date = date ?? DateTime.now(); // default to now if null
}
