import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/find_a_doctor/department_info_screen.dart';
import 'package:meditrina_01/screens/find_a_doctor/departments_model.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_info.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';
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
  List<DocModel> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
    fetchDoctors();
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

  Future<void> fetchDoctors() async {
    try {
      final response = await dio.get(
          'https://meditrinainstitute.com/report_software/api/get_all_doctor.php');
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          doctors = DoctorsListModel.fromJson(data).data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load doctors");
      }
    } catch (e) {
      print("Error fetching doctors: $e");
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
                ? buildDoctorsGrid(context)
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : buildDepartmentsList(),
          ),
        ],
      ),
    );
  }

  Widget buildDoctorsGrid(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorInfoScreen(doctor: doctors[index]),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.network(
                          doctor.docImage,
                          width: 80,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.person, size: 80, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          doctor.doctorName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          doctor.departmentName,
                          style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            MyRoutes.book_appointment,
                            arguments: {
                              'doctorName': doctor.doctorName,
                              'departmentName': doctor.departmentName,
                            },
                          );
                        },
                        child: Text("Book Appointment",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, color: color)),
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
