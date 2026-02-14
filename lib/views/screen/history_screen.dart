import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_app/providers/order_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
        backgroundColor: Colors.red,
      ),
      body: orders.isEmpty
          ? const Center(child: Text("No orders yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  child: ExpansionTile(
                    title: Text("Order #${order["id"]}"),
                    subtitle: Text(order["date"]),
                    trailing: Text(
                      "\$${order["total"]}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: order["items"].map<Widget>((item) {
                      return ListTile(
                        title: Text(item["name"]),
                        trailing: Text("\$${item["price"]}"),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
