import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'package:meditrina_01/screens/service_providers/service_provider_info.dart';

class ServiceProviders extends StatelessWidget {
  final List<Map<String, String>> imagePaths = [
    {'assets/images/1.jpg': "Health Insurance"},
    {'assets/images/2.jpg': "Corporates"},
    {'assets/images/3.jpg': "Annual Health Check-up"},
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
          final imagePath = imagePaths[index].keys.first;
          final label = imagePaths[index].values.first;

          return GestureDetector(
            onTap: () {
              print('Tapped: $label');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceProvidersInfo(logoType: label),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        imagePath,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Text(
                  //     label,
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w600,
                  //       color: color,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
