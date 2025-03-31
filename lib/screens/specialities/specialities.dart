import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MySpecialities extends StatefulWidget {
  const MySpecialities({super.key});

  @override
  State<MySpecialities> createState() => _MySpecialitiesState();
}

class _MySpecialitiesState extends State<MySpecialities> {
  List<Map<String, dynamic>> gridItems = []; // API Data
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchGridItems();
  }

  void fetchGridItems() async {
    // Simulating API Call (Replace with actual API)
    await Future.delayed(Duration(seconds: 1));

    List<Map<String, dynamic>> apiData = [
      {
        "title": "Radiology",
        "icon": "assets/images/speciality.png",
        "screen": ScreenOne()
      },
      {
        "title": "Neurological Surgery",
        "icon": "assets/images/speciality.png",
        "screen": ScreenTwo()
      },
      {
        "title": "Ambulance",
        "icon": "assets/images/speciality.png",
        "phone": "102"
      },
      {
        "title": "Pharmacy",
        "icon": "assets/images/speciality.png",
        "screen": ScreenThree()
      },
      {
        "title": "Lab Tests",
        "icon": "assets/images/speciality.png",
        "url": "https://www.labtests.com"
      },
      {
        "title": "Appointments",
        "icon": "assets/images/speciality.png",
        "url": "https://www.appointments.com"
      },
    ];

    setState(() {
      gridItems = apiData;
      filteredItems = apiData;
    });
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = gridItems
          .where((item) =>
              item["title"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _handleTap(BuildContext context, Map<String, dynamic> item) {
    if (item.containsKey("screen")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => item["screen"]));
    } else if (item.containsKey("phone")) {
      _launchDialer(item["phone"]);
    } else if (item.containsKey("url")) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewScreen(url: item["url"])));
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

  Widget buildDivider() {
    return Container(
      height: 0.5,
      color: Colors.black,
    );
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
                //
                if (rowIndex == 0) {
                  _handleTap(context, gridItems[index]);
                } else if (rowIndex == 1) {
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
                      filteredItems[rowIndex * 3 + index]["icon"],
                      color: Colors.cyan[600],
                    ),
                    SizedBox(height: 2),
                    Text(
                      filteredItems[rowIndex * 3 + index]["title"],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Specialities"),
      ),
      body: Column(
        children: [
          // Top Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(// change with api image
                    "https://via.placeholder.com/600x200"), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: _filterItems,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          buildRow(0, context),
          buildDivider(),
          buildRow(1, context),
          buildDivider(),
          buildRow(1, context),
        ],
      ),
    );
  }
}

// Dummy Screens for Navigation
class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text("Radiology")));
}

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text("Neurological Surgery")));
}

class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text("Pharmacy")));
}

// WebView Screen
class WebViewScreen extends StatelessWidget {
  final String url;
  WebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Web Page")),
    );
  }
}
