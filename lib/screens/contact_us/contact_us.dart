import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyContactUs extends StatelessWidget {
  final Color iconColor = const Color.fromARGB(255, 8, 164, 196);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/images/kk.jpg",
                width: 80, // Adjust size as needed
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14, color: iconColor), // Default style
                  children: [
                    TextSpan(text: "Book an "),
                    TextSpan(
                      text: "Appointment",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Experience Quality",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " with us."),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildContactItem(
                        icon: Icons.phone,
                        heading: 'Contact',
                        label: '0712-6669666,+91-9552552152 ',
                        onTap: () => _launchUrl('tel:9876543210'),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      SizedBox(height: 20),
                      _buildContactItem(
                        icon: Icons.email,
                        heading: 'Email',
                        label: 'info@meditrinahealthcare.com',
                        onTap: () =>
                            _launchUrl('mailto:info@meditrinahealthcare.com'),
                      ),
                      SizedBox(height: 20),
                      _buildContactItem(
                        icon: FontAwesomeIcons.facebook,
                        heading: 'Facebook',
                        label: 'facebook.com/meditrinainstitutes',
                        onTap: () => _launchUrl(
                            'https://www.facebook.com/Meditrinainstitutes/'),
                      ),
                      SizedBox(height: 20),
                      _buildContactItem(
                        icon: FontAwesomeIcons.twitter,
                        heading: 'Twitter',
                        label: 'twitter.com/tweet_meditrina',
                        onTap: () =>
                            _launchUrl('https://twitter.com/tweet_meditrina'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String heading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Icon(icon, size: 32, color: iconColor),
          SizedBox(height: 20),
          Text(
            heading,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
