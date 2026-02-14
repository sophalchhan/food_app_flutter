import 'package:flutter/material.dart';
import '../../models/food.dart';
import 'food_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Filter food list based on search query
    final filteredFood = foodList
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Food"),titleTextStyle: TextStyle(color: Colors.white,fontSize: 22),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search for food...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            query = "";
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // Result list
          Expanded(
            child: filteredFood.isEmpty
                ? const Center(child: Text("No food found 😔"))
                : ListView.builder(
                    itemCount: filteredFood.length,
                    itemBuilder: (context, index) {
                      final food = filteredFood[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            food.image,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(food.name),
                          subtitle: Text("\$${food.price}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(food.rating.toString()),
                            ],
                          ),
                          onTap: () {
                            // Go to food detail screen
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
                  ),
          ),
        ],
      ),
    );
  }
}
