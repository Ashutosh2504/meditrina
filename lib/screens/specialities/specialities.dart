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
        "icon": Icons.medical_services,
        "screen": ScreenOne()
      },
      {
        "title": "Neurological Surgery",
        "icon": Icons.healing,
        "screen": ScreenTwo()
      },
      {"title": "Ambulance", "icon": Icons.local_taxi, "phone": "102"},
      {
        "title": "Pharmacy",
        "icon": Icons.local_pharmacy,
        "screen": ScreenThree()
      },
      {
        "title": "Lab Tests",
        "icon": Icons.science,
        "url": "https://www.labtests.com"
      },
      {
        "title": "Appointments",
        "icon": Icons.calendar_today,
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
            decoration: BoxDecoration(
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

          // GridView (Scrollable)
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                crossAxisSpacing: 3, // Space between columns
                mainAxisSpacing: 3, // Space between rows
                childAspectRatio: 1,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                var item = filteredItems[index];

                return InkWell(
                  onTap: () => _handleTap(context, item),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.2),
                      borderRadius: BorderRadius.circular(
                          8), // ✅ Rounded corners // Full borders
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(item["icon"], size: 40, color: Colors.blue),
                        // SizedBox(height: 8),
                        Text(item["title"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
