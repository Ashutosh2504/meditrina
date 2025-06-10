import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditrina_01/screens/packages/package_form.dart';
import 'package:meditrina_01/screens/packages/packages_model.dart';

class PackageDetailScreen extends StatelessWidget {
  final Package package;

  const PackageDetailScreen({Key? key, required this.package})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(
      255,
      8,
      164,
      196,
    );
    return Scaffold(
      appBar: AppBar(
          backgroundColor: color,
          title: Text(
            package.packageName,
            style: TextStyle(color: Colors.white),
          )),
      body: Container(
        color: color,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(2.0),
                child: Image.network(
                  package.packageImage,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200, // set your desired width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        vertical: 14), // adjust height if needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // optional for rounded edges
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PackageBookingForm(package: package),
                      ),
                    );
                  },
                  child: Text(
                    "Book",
                    style: TextStyle(color: color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
