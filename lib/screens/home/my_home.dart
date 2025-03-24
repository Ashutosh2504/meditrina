import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor.dart';
import 'package:meditrina_01/screens/specialities/specialities.dart';
import 'package:meditrina_01/screens/venue/venue.dart';
import 'package:meditrina_01/widgets/my_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _imageUrls = [
    "assets/images/img1.jpg",
    "assets/images/img1.jpg",
    "assets/images/img1.jpg",
    "assets/images/img1.jpg"
  ];

  final List<Map<String, dynamic>> gridItems = [
    {
      "title": "Our Specialities",
      "icon": Icons.local_hospital,
      "screen": MySpecialities()
    },
    {
      "title": "Call Hospital",
      "icon": Icons.local_taxi,
      "phone": "102"
    }, // Opens dialer
    {
      "title": "Call Ambulance",
      "icon": Icons.local_pharmacy,
      // "screen": ScreenThree()
    },
    {
      "title": "Find a Doctor",
      "icon": Icons.science,
      "screen": MyDoctor(),
    },

    {
      "title": "Facebook",
      "icon": Icons.calendar_today,
      "url": "https://www.appointments.com"
    }, // Opens WebView
    {
      "title": "Twitter",
      "icon": Icons.transfer_within_a_station,
      "url": "https://www.appointments.com"
    }, // Opens WebView
  ];

  void _handleTap(BuildContext context, Map<String, dynamic> item) {
    if (item.containsKey("screen")) {
      // Navigate to a new screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => item["screen"]),
      );
    } else if (item.containsKey("phone")) {
      // Open the dialer for the ambulance
      _launchDialer(item["phone"]);
    }
  }

  void _launchDialer(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update UI
    });
  }

  void _stopAutoSlide() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: GestureDetector(
                onPanDown: (_) => _stopAutoSlide(),
                onPanEnd: (_) => _startAutoSlide(),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _imageUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: _currentPage == index
                          ? 1.0
                          : 0.6, // Smooth fade-in effect
                      child: Transform.scale(
                        scale:
                            _currentPage == index ? 1.0 : 0.9, // Scale effect
                        child:
                            Image.asset(_imageUrls[index], fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_imageUrls.length, (index) {
                return Container(
                  margin: EdgeInsets.all(4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
            Center(
              child: SizedBox(
                height: 50, // Adjust height as needed
                child: Marquee(
                  text: 'Meditrina Institute Of Medical Sciences... 🚀',
                  style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 50.0, // Space between loops
                  velocity: 50.0, // Speed of movement
                  pauseAfterRound: Duration(seconds: 1), // Pause between rounds
                  startPadding: 10.0, // Padding before start
                  accelerationDuration: Duration(seconds: 1), // Smooth start
                  decelerationDuration:
                      Duration(milliseconds: 500), // Smooth stop
                ),
              ),
            ),
            SizedBox(
              height: 270,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 columns
                    crossAxisSpacing: 3, // Space between columns
                    mainAxisSpacing: 3, // Space between rows
                    childAspectRatio: 1,
                  ),
                  itemCount: gridItems.length, // 2 rows * 3 columns
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _handleTap(context, gridItems[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.2),
                          borderRadius: BorderRadius.circular(
                              8), // ✅ Rounded corners // Full borders
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(gridItems[index]["icon"],
                                size: 40, color: Colors.cyan[600]),
                            SizedBox(height: 4),
                            Text(gridItems[index]["title"]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // ✅ Background color (optional)
                  border:
                      Border.all(color: Colors.black, width: 0.5), // ✅ Border
                  borderRadius: BorderRadius.circular(12), // ✅ Rounded corners
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black26, // ✅ Soft shadow effect
                  //     blurRadius: 4,
                  //     spreadRadius: 1,
                  //     offset: Offset(2, 2),
                  //   ),
                  // ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 40, color: Colors.blue),
                    SizedBox(height: 4),
                    Text("Item"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // ✅ Background color (optional)
                  border:
                      Border.all(color: Colors.black, width: 0.5), // ✅ Border
                  borderRadius: BorderRadius.circular(12), // ✅ Rounded corners
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black26, // ✅ Soft shadow effect
                  //     blurRadius: 4,
                  //     spreadRadius: 1,
                  //     offset: Offset(2, 2),
                  //   ),
                  // ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 40, color: Colors.blue),
                    SizedBox(height: 4),
                    Text("Item}"),
                  ],
                ),
              ),
            ),
            Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // ✅ Space between containers
                children: [
                  // 🖼️ First Image Container with Text
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/img1.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8), // ✅ Space between image and text
                      Text(
                        "About Us", // ✅ Change text as needed
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),

                  // 🖼️ Second Image Container with Text
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/img1.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8), // ✅ Space between image and text
                      Text(
                        "Our Facilities", // ✅ Change text as needed
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ]),
            Container(
              width: double.infinity, // ✅ Full width
              padding: EdgeInsets.all(16), // ✅ Padding for text
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(12), // ✅ Rounded corners
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📌 Title/Text at the Top
                  Text(
                    "Meditrina Hospital, 278, Central Bazar Road, Ramdaspeth", // ✅ Change text as needed
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: const Color.fromARGB(255, 8, 91, 99)),
                  ),
                  SizedBox(height: 8), // ✅ Space between text & image

                  // 📌 Image with Floating Button Overlay (No Shadow)
                  Stack(
                    alignment: Alignment.bottomCenter, // ✅ Centers the button
                    children: [
                      // 🖼️ Image Below the Text
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // ✅ Rounded image corners
                        child: Image.asset(
                          "assets/images/img1.jpg",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // 📌 Floating Button in Bottom Center
                      MyVenue(),
                    ],
                  ),
                ],
              ),
            ),
            MySlider(),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: List.generate(3, (index) => buildGridItem(index + 1)),
            // ),

            // Single line separator
          ],
        ),
      ),
    );
  }

  // // Grid item widget (Icon + Text)
  // Widget buildGridItem(int index) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(Icons.star, size: 40, color: Colors.blue),
  //       SizedBox(height: 4),
  //       Text("Item $index"),
  //     ],
  //   );
  // }
}
