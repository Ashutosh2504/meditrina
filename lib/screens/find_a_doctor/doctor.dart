import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/find_a_doctor/department_info_screen.dart';
import 'package:meditrina_01/screens/find_a_doctor/departments_model.dart';
import 'package:meditrina_01/util/routes.dart';

class MyDoctor extends StatefulWidget {
  const MyDoctor({super.key});

  @override
  State<MyDoctor> createState() => _MyDoctorState();
}

class _MyDoctorState extends State<MyDoctor> {
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );
  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> filteredDepartments = [];
  int _selectedIndex = 1;
  Dio dio = Dio();
  bool isLoading = true;

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
                    'name': dept['department_name'],
                    'icon': dept['logo_url'], // Fetching network image URL
                  }));
          filteredDepartments = departments;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching departments: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          'Doctors & Departments',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              "assets/images/stetho.jpg",
              width: double.infinity, // Adjust size as needed
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Card(
                    child: Container(
                      color: _selectedIndex == 1 ? color : Colors.grey[300],
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          'Departments',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedIndex == 1 ? Colors.white : color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Card(
                    child: Container(
                      color: _selectedIndex == 0 ? color : Colors.grey[300],
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          'Doctors',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedIndex == 0 ? Colors.white : color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _selectedIndex == 0
                ? buildDoctorsGrid()
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : buildDepartmentsList(),
          ),
        ],
      ),
    );
  }

  Widget buildDoctorsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              MyRoutes.doctor_info,
            );
          },
          child: Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/images/AjayBulle.jpg",
                    width: 80, // Adjust size as needed
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 8),
                Text("Doctor Name",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: color)),
                SizedBox(height: 4),
                Text("Specialization"),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MyRoutes.book_appointment,
                    );
                  },
                  child: Text("Book Appointment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: color)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDepartmentsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Departments',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                filteredDepartments = departments
                    .where((dept) => dept['name']!
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: filteredDepartments.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  child: ListTile(
                      leading: Image.network(
                        filteredDepartments[index]['icon'],
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: Colors.red),
                      ),
                      title: Text(
                        filteredDepartments[index]['name']!,
                        style: TextStyle(
                            color: const Color.fromARGB(
                          255,
                          8,
                          164,
                          196,
                        )),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DepartmentInfoScreen(
                                      departmentName: filteredDepartments[index]
                                          ['name']!,
                                    )));
                      }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
