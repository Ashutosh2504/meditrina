import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/find_a_doctor/department_info_screen.dart';
import 'package:meditrina_01/screens/specialities/specailities_info.dart';
import 'package:meditrina_01/util/webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MySpecialities extends StatefulWidget {
  const MySpecialities({super.key});

  @override
  State<MySpecialities> createState() => _MySpecialitiesState();
}

class _MySpecialitiesState extends State<MySpecialities> {
  List<Map<String, dynamic>> departments = []; // Stores API Data
  List<Map<String, dynamic>> filteredDepartments = [];
  bool isLoading = true; // For loading state
  Color color = const Color.fromARGB(255, 8, 164, 196);
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {
      final response = await dio.get(
          'https://meditrinainstitute.com/report_software/api/get_department.php');
      if (response.statusCode == 200) {
        setState(() {
          departments = List<Map<String, dynamic>>.from(
              response.data["data"].map((dept) => {
                    'title': dept['department_name'],
                    'icon': dept['logo_url'], // Fetching network image URL
                  }));
          filteredDepartments = departments;
          isLoading = false;
        });
        setState(() {
          filteredDepartments = departments;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching departments: $e');
      setState(() => isLoading = false);
    }
  }

  void _filterItems(String query) {
    setState(() {
      filteredDepartments = departments
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

  Widget buildGridWithSeparators() {
    if (filteredDepartments.isEmpty) {
      return Center(child: Text("No items found"));
    }

    int columnCount = filteredDepartments.length == 1
        ? 1
        : (filteredDepartments.length == 2 ? 2 : 3);

    return Column(
      children: [
        for (int row = 0;
            row < (filteredDepartments.length / columnCount).ceil();
            row++) ...[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(columnCount, (col) {
                int index = row * columnCount + col;
                bool isLastRow =
                    row == (filteredDepartments.length / columnCount).floor();
                bool isLastItemInLastRow =
                    isLastRow && index == filteredDepartments.length - 1;

                if (index >= filteredDepartments.length) {
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

                final item = filteredDepartments[index];

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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MySpecialitiesInfo(
                                      department: filteredDepartments[index],
                                    )));
                      },
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
          : SafeArea(
              child: Column(
                children: [
                  // Top Image
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/aabbuuss.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Everything else scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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

                          // Grid content
                          buildGridWithSeparators(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
