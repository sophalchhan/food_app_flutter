import 'package:flutter/material.dart';
import 'package:food_app/views/screen/KqrPaymentScreen.dart';
import 'package:provider/provider.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  String paymentMethod = "cash"; // default

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  void _scrollToFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
    // Scroll a little so the field is visible
    _scrollController.animateTo(
      focusNode.offset.dy,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        backgroundColor: Colors.red,
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "No items to checkout 🛒",
                style: TextStyle(fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Information",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _inputField("Full Name", _nameController, focusNode: _nameFocus),
                    const SizedBox(height: 10),
                    _inputField("Phone Number", _phoneController,
                        keyboardType: TextInputType.phone,
                        focusNode: _phoneFocus),
                    const SizedBox(height: 10),
                    _inputField("Address", _addressController,
                        focusNode: _addressFocus),
                    const SizedBox(height: 24),

                    const Text(
                      "Payment Method",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                      value: "cash",
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      title: const Text("Cash on Delivery"),
                    ),
                    RadioListTile(
                      value: "kqr",
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      title: const Text("Pay by KHQR"),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Order Summary",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...cart.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("${item.food.name} × ${item.quantity}"),
                            ),
                            Text(
                              "\$${(item.food.price * item.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          "\$${cart.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Validate form first
                  if (_formKey.currentState!.validate()) {
                    if (paymentMethod == "cash") {
                      context.read<OrderProvider>().addOrder(
                          cart.items.map((e) => e.food).toList(),
                          cart.totalPrice);
                      cart.clearCart();
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text("Order Successful 🎉"),
                                content:
                                    const Text("Cash on delivery selected."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              KqrPaymentScreen(amount: cart.totalPrice),
                        ),
                      );
                    }
                  } else {
                    // Scroll to first invalid field
                    if (_nameController.text.isEmpty) {
                      _scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      _nameFocus.requestFocus();
                    } else if (_phoneController.text.isEmpty) {
                      _scrollController.animateTo(60,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      _phoneFocus.requestFocus();
                    } else if (_addressController.text.isEmpty) {
                      _scrollController.animateTo(120,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      _addressFocus.requestFocus();
                    }
                  }
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
    );
  }

  Widget _inputField(String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      FocusNode? focusNode}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $hint";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
