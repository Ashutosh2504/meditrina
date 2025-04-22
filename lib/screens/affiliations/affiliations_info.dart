import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/affiliations/affiliations_form.dart';
import 'package:meditrina_01/screens/affiliations/affiliations_model.dart';

class AffiliationDetailsScreen extends StatelessWidget {
  Color color = const Color.fromARGB(255, 8, 164, 196);

  final Affiliation affiliation;

  AffiliationDetailsScreen({required this.affiliation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(affiliation.logoName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 3 / 1,
                child: Image.network(
                  affiliation.logoName,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(height: 16),
              // Text(
              //   'Logo Name: ${affiliation.logoName}',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              const SizedBox(height: 8),
              // Text('Date: ${affiliation.date}'),
              // Text('Status: ${affiliation.status}'),
              // Text('Logo Type: ${affiliation.logoType}'),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: color,
              //     padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              //   ),
              //   onPressed: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (context) => AffiliationsForm()),
              //     // );
              //   },
              //   child: Text("Book", style: TextStyle(color: Colors.white)),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
