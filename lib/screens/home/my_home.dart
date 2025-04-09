import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor.dart';
import 'package:meditrina_01/screens/our_facilities/our_facilities.dart';
import 'package:meditrina_01/screens/specialities/specialities.dart';
import 'package:meditrina_01/screens/venue/venue.dart';
import 'package:meditrina_01/util/routes.dart';
import 'package:meditrina_01/util/webview.dart';
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
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );
  Timer? _timer;

  final List<String> _imageUrls = [
    "assets/images/top_image.jpg",
    "assets/images/abuss.jpg",
    "assets/images/aabbuuss.jpg",
    "assets/images/s1.png",
  ];

  final List<Map<String, dynamic>> gridItems = [
    {
      "title": "Our Specialities",
      "icon": "assets/images/speciality.png",
      "screen": MySpecialities()
    },
    {
      "title": "Call Hospital",
      "icon": "assets/images/dd5.png",
      "phone": "07126669666"
    },
    {
      "title": "Call Ambulance",
      "icon": "assets/images/q18.png",
      "phone": "07126669612"
      // "screen": ScreenThree()
    },
    {
      "title": "Find a Doctor",
      "icon": "assets/images/dd3.png",
      "screen": MyDoctor(),
    },

    {
      "title": "Facebook",
      "icon": "assets/images/dd7.png",
      "url": "https://www.facebook.com/Meditrinainstitutes/"
    }, // Opens WebView
    {
      "title": "Twitter",
      "icon": "assets/images/twitter.png",
      "url": "https://x.com/meditrinaindia"
    }, // Opens WebView
  ];

  Future<void> _handleTap(
      BuildContext context, Map<String, dynamic> item) async {
    if (item.containsKey("screen")) {
      // Navigate to a new screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => item["screen"]),
      );
    } else if (item.containsKey("phone")) {
      // Open the dialer for the ambulance
      _launchDialer(item["phone"]);
    } else if (item.containsKey("url")) {
      // Open the dialer for the ambulance

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctxt) =>
              WebviewComponent(title: item["title"], webviewUrl: item["url"]),
        ),
      );
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

  Widget buildRow(int rowIndex, BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: queryData.size.width / 3,
          height: queryData.size.height / 8, // Fixed width
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: index == 0 ? Colors.transparent : Colors.black,
                width: index == 0 ? 0 : 0.5, // Vertical separation
              ),
            ),
          ),
          alignment: Alignment.center,
          // padding: EdgeInsets.all(8), // Reduce padding to fit content
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (rowIndex == 0) {
                  _handleTap(context, gridItems[index]);
                } else {
                  _handleTap(context, gridItems[rowIndex * 3 + index]);
                }
              },
              child: Container(
                width: double.infinity, // Ensure full width
                height: 100,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      gridItems[rowIndex * 3 + index]["icon"],
                      color: color,
                    ),
                    SizedBox(height: 2),
                    Text(
                      gridItems[rowIndex * 3 + index]["title"],
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

//just now commented
  // Widget buildRow(int rowIndex) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: List.generate(3, (index) {
  //       return Container(
  //         width: 100, // Fixed width to avoid overflow
  //         decoration: BoxDecoration(
  //           border: Border(
  //             // top: BorderSide(color: Colors.black, width: 2),
  //             // bottom: BorderSide(color: Colors.black, width: 2),
  //             left: BorderSide(
  //                 color: index == 0 ? Colors.transparent : Colors.black,
  //                 width: index == 0 ? 0 : 0.5), // Vertical separation
  //           ),
  //         ),
  //         alignment: Alignment.center,
  //         padding: EdgeInsets.all(16),
  //         child: Text(
  //           items[rowIndex * 3 + index],
  //           style: TextStyle(fontSize: 18),
  //         ),
  //       );
  //     }),
  //   );
  // }

  Widget buildDivider() {
    return Container(
      height: 0.5,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meditrina Hospital",
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
      ),
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
                child: Row(children: [
                  // Image.asset(
                  //   'assets/images/new.gif', // Adjust the path to your asset folder
                  //   width: 60,
                  //   height: 60,
                  //   fit: BoxFit.cover,
                  // ),
                  Expanded(
                    child: Marquee(
                      text: 'Meditrina Institute Of Medical Sciences... 🚀',
                      style: TextStyle(
                          color: color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      blankSpace: 50.0, // Space between loops
                      velocity: 50.0, // Speed of movement
                      pauseAfterRound:
                          Duration(seconds: 1), // Pause between rounds
                      startPadding: 10.0, // Padding before start
                      accelerationDuration:
                          Duration(seconds: 1), // Smooth start
                      decelerationDuration: Duration(milliseconds: 500),
                      // Smooth stop
                    ),
                  ),
                ]),
              ),
            ),

            buildRow(0, context),
            buildDivider(),
            buildRow(1, context),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MyRoutes.book_appointment,
                  arguments: {
                    'doctorName': '',
                    'departmentName': '',
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/book_appointment.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/relationship_card.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
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
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black26,
                          //     blurRadius: 2,
                          //     spreadRadius: 1,
                          //     offset: Offset(2, 2),
                          //   ),
                          // ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/about.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 8), // ✅ Space between image and text
                      Text(
                        "About Us", // ✅ Change text as needed
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: color),
                      ),
                    ],
                  ),

                  // 🖼️ Second Image Container with Text
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OurFacilitiesScreen(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black26,
                            //     blurRadius: 2,
                            //     spreadRadius: 1,
                            //     offset: Offset(2, 2),
                            //   ),
                            // ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/our_facilities.jpg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 8), // ✅ Space between image and text
                        Text(
                          "Our Facilities", // ✅ Change text as needed
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: color),
                        ),
                      ],
                    ),
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
                        color: color),
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
                          "assets/images/google.jpg",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.fill,
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
