import 'package:flutter/material.dart';
import 'package:meditrina_01/util/webview.dart';
import 'package:url_launcher/url_launcher.dart';

class MyContactUs extends StatefulWidget {
  const MyContactUs({super.key});

  @override
  State<MyContactUs> createState() => _MyContactUsState();
}

class _MyContactUsState extends State<MyContactUs> {
  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final telUrl = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(telUrl))) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (ctxt) =>
      //         WebviewComponent(title: "Phone", webviewUrl: telUrl),
      //   ),
      // );
      await launchUrl(
        Uri.parse(telUrl),
        mode: LaunchMode.externalApplication, // Ensures it opens in a dialer
      );
    } else {
      throw 'Could not launch $telUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/img1.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            _contactItem(
                'Phone', '123-456-7890', () => _launchDialer('1234567890')),
            _contactItem('Email', 'info@example.com',
                () => _launchUrl('mailto:info@example.com')),
            _contactItem('Facebook', 'fb.com/yourpage',
                () => _launchUrl('https://facebook.com/yourpage')),
            _contactItem('Twitter', '@yourtwitter',
                () => _launchUrl('https://twitter.com/yourtwitter')),
          ],
        ),
      ),
    );
  }

  Widget _contactItem(String title, String detail, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              detail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
