import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/online_pathalogy/online_pathalogy_model.dart';
import 'package:meditrina_01/screens/online_pathalogy/pathalogy_payment_details.dart';

class PathalogyPayment extends StatelessWidget {
  final List<OnlinePathalogy> cartItems;

  const PathalogyPayment({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(
      0,
      (sum, item) => sum + double.tryParse(item.fees)!.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Cart",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 164, 196),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("No items in the cart"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          title: Text(item.testName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category: ${item.category}"),
                              // Text("Date: ${item.date}"),
                            ],
                          ),
                          trailing: Text("₹${item.fees}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ₹$totalAmount",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PathologyPaymentDetailsScreen(
                                cartItems: cartItems,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 8, 164, 196),
                        ),
                        child: const Text("Proceed",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
