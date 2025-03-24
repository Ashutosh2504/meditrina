import 'package:flutter/material.dart';
import 'package:meditrina_01/util/routes.dart';

class MyDoctor extends StatefulWidget {
  const MyDoctor({super.key});

  @override
  State<MyDoctor> createState() => _MyDoctorState();
}

class _MyDoctorState extends State<MyDoctor> {
  List<Map<String, dynamic>> filteredDepartments = [];
  int _selectedIndex = 1;

  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Rajesh Kumar',
      'designation': 'Cardiologist',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Dr. Anjali Sharma',
      'designation': 'Neurologist',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Dr. Vivek Mehta',
      'designation': 'Orthopedic',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Dr. Priya Deshmukh',
      'designation': 'Gynecologist',
      'image': 'https://via.placeholder.com/150'
    },
  ];

  final List<Map<String, dynamic>> departments = [
    {'name': 'Cardiology', 'icon': Icons.favorite},
    {'name': 'Neurology', 'icon': Icons.grain_outlined},
    {'name': 'Orthopedics', 'icon': Icons.accessibility_new},
    {'name': 'Gynecology', 'icon': Icons.pregnant_woman},
  ];

  @override
  void initState() {
    super.initState();
    filteredDepartments = departments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors & Departments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Card(
                    child: Container(
                      color:
                          _selectedIndex == 1 ? Colors.blue : Colors.grey[300],
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          'Departments',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
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
                      color:
                          _selectedIndex == 0 ? Colors.blue : Colors.grey[300],
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          'Doctors',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
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
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              MyRoutes.doctor_info,
              arguments: {
                'doctorName': doctors[index]['name'],
                'departmentName': 'Cardiology',
              },
            );
          },
          child: Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.network(doctors[index]['image']!, height: 80, width: 80),
                SizedBox(height: 8),
                Text(doctors[index]['name']!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                SizedBox(height: 4),
                Text(doctors[index]['designation']!),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MyRoutes.book_appointment,
                      arguments: {
                        'doctorName': doctors[index]['name'],
                        'departmentName': 'Cardiology',
                      },
                    );
                  },
                  child: Text("Book Appointment"),
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
          child: ListView.builder(
            itemCount: filteredDepartments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  filteredDepartments[index]['icon'],
                  color: Colors.blueAccent,
                ),
                title: Text(
                  filteredDepartments[index]['name']!,
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onTap: () => print(
                    "Selected Department: ${filteredDepartments[index]['name']}"),
              );
            },
          ),
        ),
      ],
    );
  }
}
