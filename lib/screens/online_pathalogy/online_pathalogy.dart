import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'package:meditrina_01/screens/online_pathalogy/online_pathalogy_model.dart';
import 'package:meditrina_01/screens/online_pathalogy/pathalogy_payment.dart';

class MyOnlinePathalogy extends StatefulWidget {
  const MyOnlinePathalogy({super.key});

  @override
  State<MyOnlinePathalogy> createState() => My_OnlinePathalogyState();
}

class My_OnlinePathalogyState extends State<MyOnlinePathalogy> {
  List<OnlinePathalogy> allTests = [];
  List<OnlinePathalogy> filteredTests = [];
  List<OnlinePathalogy> selectedTests = [];

  bool isLoading = true;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchTests();
  }

  Future<void> fetchTests() async {
    try {
      final response = await dio.get(
        'https://meditrinainstitute.com/report_software/api/get_tests.php',
      );

      final model = OnlinePathalogyModel.fromJson(response.data);

      setState(() {
        allTests = model.data;
        filteredTests = allTests;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tests: $e');
      setState(() => isLoading = false);
    }
  }

  void _filterByTestName(String query) {
    setState(() {
      filteredTests = allTests
          .where((test) =>
              test.testName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Pathology Tests"),
        backgroundColor: const Color.fromARGB(255, 8, 164, 196),
      ),
      drawer: MyDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Box
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: TextField(
                //     onChanged: _filterByTestName,
                //     decoration: InputDecoration(
                //       hintText: 'Search by test name',
                //       prefixIcon: const Icon(Icons.search),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //   ),
                // ),

                // List of Tests
                Expanded(
                    child: filteredTests.isEmpty
                        ? Text('No tests found')
                        : buildPathologyTestsList()),
              ],
            ),
    );
  }

  Widget buildPathologyTestsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Tests',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                filteredTests = allTests
                    .where((test) => test.testName
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              itemCount: filteredTests.length,
              itemBuilder: (context, index) {
                final test = filteredTests[index];
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.medical_services, color: Colors.blue),
                    title: Text(
                      test.testName,
                      style: TextStyle(
                        color: Color.fromARGB(255, 8, 164, 196),
                      ),
                    ),
                    subtitle: Text("₹${test.fees}"),
                    trailing: IconButton(
                      icon: Icon(
                        selectedTests.contains(test)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: selectedTests.contains(test)
                            ? Color.fromARGB(255, 8, 164, 196)
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (selectedTests.contains(test)) {
                            selectedTests.remove(test);
                          } else {
                            selectedTests.add(test);
                          }
                        });
                      },
                    ),
                    onTap: () {
                      // Handle test click (optional)
                    },
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: Icon(
              Icons.payment,
              color: Colors.white,
            ),
            label: Text(
              'Proceed to Payment (${selectedTests.length})',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 8, 164, 196),
            ),
            onPressed: selectedTests.isEmpty
                ? null
                : () {
                    // Navigate to payment screen with selectedTests
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PathalogyPayment(selectedTests: selectedTests),
                      ),
                    );
                  },
          ),
        ),
      ],
    );
  }
}
