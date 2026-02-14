import 'package:food_app/models/food.dart';

class CardController {
  List<Food> card_item = [];

  void addtocard(Food food) {
    card_item.add(
      Food(
        name: food.name,
        price: food.price,
        category: food.category,
        rating: food.rating,
        description: food.description,
        image: food.image,
        qty: food.qty,
      ),
    );
  }
}
