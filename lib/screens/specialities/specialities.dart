import 'package:flutter/material.dart';
import 'package:meditrina_01/util/webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MySpecialities extends StatefulWidget {
  const MySpecialities({super.key});

  @override
  State<MySpecialities> createState() => _MySpecialitiesState();
}

class _MySpecialitiesState extends State<MySpecialities> {
  List<Map<String, dynamic>> gridItems = []; // Stores API Data
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoading = true; // For loading state
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );

  @override
  void initState() {
    super.initState();
    fetchGridItems();
  }

  Future<void> fetchGridItems() async {
    try {
      // Simulating API Call (Replace with actual API request)
      await Future.delayed(Duration(seconds: 1));

      List<Map<String, dynamic>> apiData = [
        {
          "title": "Radiology",
          "icon": "https://via.placeholder.com/80",
          "screen": ScreenOne()
        },
        {
          "title": "Neurological Surgery",
          "icon": "https://via.placeholder.com/80",
          "screen": ScreenTwo()
        },
        {
          "title": "Ambulance",
          "icon": "https://via.placeholder.com/80",
          "phone": "102"
        },
        {
          "title": "Pharmacy",
          "icon": "https://via.placeholder.com/80",
          "screen": ScreenThree()
        },
        {
          "title": "Lab Tests",
          "icon": "https://via.placeholder.com/80",
          "url": "https://www.labtests.com"
        },
        {
          "title": "Appointments",
          "icon": "https://via.placeholder.com/80",
          "url": "https://www.appointments.com"
        },
        {
          "title": "Lab Tests",
          "icon": "https://via.placeholder.com/80",
          "url": "https://www.labtests.com"
        },
        {
          "title": "Appointments",
          "icon": "https://via.placeholder.com/80",
          "url": "https://www.appointments.com"
        },
      ];

      setState(() {
        gridItems = apiData;
        filteredItems = apiData;
        isLoading = false; // Data is loaded
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
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
              builder: (context) => WebviewComponent(
                    webviewUrl: item["url"],
                    title: "",
                  )));
    }
  }

  void _launchDialer(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  // Widget buildGrid() {
  //   if (filteredItems.isEmpty) {
  //     return Center(child: Text("No items found"));
  //   }

  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: filteredItems.length,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       childAspectRatio: 1.0,
  //     ),
  //     itemBuilder: (context, index) {
  //       final item = filteredItems[index];
  //       return InkWell(
  //         onTap: () => _handleTap(context, item),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                 'assets/images/img1.jpg',
  //                 width: 60,
  //                 height: 60,
  //                 fit: BoxFit.cover,
  //               ),
  //               // Image.network(
  //               //   item["icon"],
  //               //   width: 60,
  //               //   height: 60,
  //               //   errorBuilder: (context, error, stackTrace) => Icon(
  //               //     Icons.broken_image,
  //               //     size: 50,
  //               //     color: Colors.red,
  //               //   ),
  //               // ),
  //               SizedBox(height: 5),
  //               Text(
  //                 item["title"],
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 12),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget buildGridWithSeparators() {
    if (filteredItems.isEmpty) {
      return Center(child: Text("No items found"));
    }

    int columnCount =
        filteredItems.length == 1 ? 1 : (filteredItems.length == 2 ? 2 : 3);

    return Column(
      children: [
        for (int row = 0;
            row < (filteredItems.length / columnCount).ceil();
            row++) ...[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(columnCount, (col) {
                int index = row * columnCount + col;
                bool isLastRow =
                    row == (filteredItems.length / columnCount).floor();
                bool isLastItemInLastRow =
                    isLastRow && index == filteredItems.length - 1;

                if (index >= filteredItems.length) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: col == 0
                              ? BorderSide.none
                              : BorderSide(color: Colors.black, width: 0.5),
                          bottom: BorderSide
                              .none, // No bottom border for empty cells
                        ),
                      ),
                    ),
                  );
                }

                final item = filteredItems[index];

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: col == 0
                            ? BorderSide.none
                            : BorderSide(color: Colors.black, width: 0.5),
                        bottom: BorderSide(color: Colors.black, width: 0.5),
                        right: isLastItemInLastRow
                            ? BorderSide(color: Colors.black, width: 0.5)
                            : BorderSide.none,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _handleTap(context, item),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              item["icon"],
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  item["title"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: color),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: color,
          title: Text(
            "Our Specialities",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top Image
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://via.placeholder.com/600x200"), // Replace with API image
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),

                Expanded(
                  child: buildGridWithSeparators(),
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
