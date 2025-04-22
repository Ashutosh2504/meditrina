import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:meditrina_01/screens/about_us/about_us_model.dart';

class MyAboutUs extends StatefulWidget {
  const MyAboutUs({super.key});

  @override
  State<MyAboutUs> createState() => _MyAboutUsState();
}

class _MyAboutUsState extends State<MyAboutUs> {
  AboutUsModel? aboutUsData;
  bool isLoading = true;
  final Dio dio = Dio();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  void initState() {
    super.initState();
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    final response = await http.get(Uri.parse(
        "https://meditrinainstitute.com/report_software/api/get_about_us.php"));
    if (response.statusCode == 200) {
      setState(() {
        aboutUsData = aboutUsModelFromJson(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
      debugPrint("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color, // or your custom color
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : aboutUsData == null
              ? const Center(child: Text("No data found"))
              : SingleChildScrollView(
                  // padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        //borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/abuss.jpg', // Replace with your image
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        ),
                      ),
                      // Replace with your desired image
                      const SizedBox(height: 20),
                      Html(
                        data: aboutUsData!.data.first.content,
                        style: {
                          "body": Style(fontSize: FontSize(16)),
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
