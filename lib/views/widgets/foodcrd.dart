import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart';

class Foodcrd extends StatelessWidget {
   Foodcrd({super.key});

  final popularFood =
    foodList.where((food) => food.rating >= 4.5).toList();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        children: [

        ],
      ),
    );
  }
}