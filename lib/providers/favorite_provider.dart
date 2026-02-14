import 'package:flutter/material.dart';
import '../models/food.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Food> _favorites = [];

  List<Food> get favorites => _favorites;

  bool isFavorite(Food food) {
    return _favorites.contains(food);
  }

  void toggleFavorite(Food food) {
    if (isFavorite(food)) {
      _favorites.remove(food);
    } else {
      _favorites.add(food);
    }
    notifyListeners();
  }
}
