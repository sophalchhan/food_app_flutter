import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/providers/order_provider.dart';

class KqrPaymentScreen extends StatelessWidget {
  final double amount;

  const KqrPaymentScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay by KHQR"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Total: \$${amount.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/khqr/khqr.jpg",
                  height: 260,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Scan this KHQR with ABA, ACLEDA, Wing or any banking app.",
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                context.read<OrderProvider>().addOrder(
                    cart.items.map((e) => e.food).toList(), amount);
                cart.clearCart();
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text("Payment Successful 🎉"),
                          content: const Text("Your order has been placed."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            )
                          ],
                        ));
              },
              child: const Text(
                "I have paid",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
