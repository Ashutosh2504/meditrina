import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor.dart';

class HomeCareAssistanceScreen extends StatefulWidget {
  @override
  _HomeCareAssistanceScreenState createState() =>
      _HomeCareAssistanceScreenState();
}

class _HomeCareAssistanceScreenState extends State<HomeCareAssistanceScreen> {
  // Track which image has been clicked to show/hide the list
  int? _selectedImageIndex;
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HomeCare Assistance',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image 1
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImageIndex = (_selectedImageIndex == 0)
                        ? null
                        : 0; // Toggle visibility
                  });
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/charges.jpg', // Replace with your image path
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    if (_selectedImageIndex == 0)
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Home visit by GP is Rs500/.'),
                            // Text('Text 2 for Image 1'),
                            // Text('Text 3 for Image 1'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Image 2
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImageIndex = (_selectedImageIndex == 1)
                        ? null
                        : 1; // Toggle visibility
                  });
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/physio.jpg', // Replace with your image path
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    if (_selectedImageIndex == 1)
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Home visit by GP is Rs1000/.'),
                            // Text('Text 2 for Image 2'),
                            // Text('Text 3 for Image 2'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Image 3
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImageIndex = (_selectedImageIndex == 2)
                        ? null
                        : 2; // Toggle visibility
                  });
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/sample.jpg', // Replace with your image path
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    if (_selectedImageIndex == 2)
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('0 to 5km radius from hospital is free.'),
                            SizedBox(height: 5),
                            Text('5km to 10km Rs200/.'),
                            SizedBox(height: 5),
                            Text('Beyond 10km Rs500/.'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
