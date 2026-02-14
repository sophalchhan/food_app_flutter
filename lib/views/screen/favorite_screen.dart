import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),titleTextStyle: TextStyle(color: Colors.white,fontSize: 22),
        backgroundColor: Colors.red,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favProvider, _) {
          final List<Food> favorites = favProvider.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Text("No favorites yet 😔"),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final food = favorites[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.asset(
                    food.image,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(food.name),
                  subtitle: Text("\$${food.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favProvider.toggleFavorite(food); // remove from favorites
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodDetailScreen(food: food),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
