import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_app/providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  // Map status to color
  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Paid":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Map status to step index
  int getStep(String status) {
    switch (status) {
      case "Pending":
        return 0;
      case "Paid":
        return 1;
      case "Delivered":
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.red,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text("No orders yet 🛒", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final date = order.date ?? DateTime.now();
                int step = getStep(order.status);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order total
                        Text(
                          "Order \$${order.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Order date
                        Text(
                          DateFormat('yyyy-MM-dd - kk:mm').format(date),
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 12),

                        // Stepper style progress bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Pending
                            Column(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: step >= 0
                                      ? Colors.orange
                                      : Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Pending",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Divider(
                                color: step >= 1 ? Colors.blue : Colors.grey,
                                thickness: 2,
                              ),
                            ),
                            // Paid
                            Column(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: step >= 1 ? Colors.blue : Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Paid",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Divider(
                                color: step >= 2 ? Colors.green : Colors.grey,
                                thickness: 2,
                              ),
                            ),
                            // Delivered
                            Column(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: step >= 2 ? Colors.green : Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Delivered",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        const Divider(),

                        // Ordered Items
                        Column(
                          children: order.items.map((item) {
                            return ListTile(
                              title: Text(item.name),
                              trailing: Text("\$${item.price}"),
                            );
                          }).toList(),
                        ),

                        // Optional: Button to simulate status update
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              String nextStatus;
                              if (order.status == "Pending") {
                                nextStatus = "Paid";
                              } else if (order.status == "Paid") {
                                nextStatus = "Delivered";
                              } else {
                                nextStatus = "Delivered";
                              }

                              context.read<OrderProvider>().updateOrderStatus(
                                index,
                                nextStatus,
                              );
                            },
                            child: const Text("Next Step"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(100, 36),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
