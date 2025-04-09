import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';

class ServiceProviders extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(255, 8, 164, 196);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Service Providers",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
      drawer: MyDrawer(),
      body: ListView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Do something on tap
              print('Tapped image ${index + 1}');
              // You can navigate or show a dialog here
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    imagePaths[index],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
