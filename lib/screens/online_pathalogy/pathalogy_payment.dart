import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/online_pathalogy/online_pathalogy_model.dart';

class PathalogyPayment extends StatelessWidget {
  final List<OnlinePathalogy> selectedTests;

  const PathalogyPayment({super.key, required this.selectedTests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: ListView.builder(
        itemCount: selectedTests.length,
        itemBuilder: (context, index) {
          final test = selectedTests[index];
          return ListTile(
            title: Text(test.testName),
            subtitle: Text("₹${test.fees}"),
          );
        },
      ),
    );
  }
}
