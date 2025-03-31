import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/find_a_doctor/departments_model.dart';

class DepartmentInfoScreen extends StatefulWidget {
  final String departmentName;

  const DepartmentInfoScreen({super.key, required this.departmentName});

  @override
  State<DepartmentInfoScreen> createState() => _DepartmentInfoScreenState();
}

class _DepartmentInfoScreenState extends State<DepartmentInfoScreen> {
  Dio dio = Dio();
  bool isLoading = true;
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );
  String departmentContent = "";

  @override
  void initState() {
    super.initState();
    fetchDepartmentInfo();
  }

  Future<void> fetchDepartmentInfo() async {
    try {
      final response = await dio.get(
        'https://meditrinainstitute.com/report_software/api/get_department_content.php',
        queryParameters: {'department': widget.departmentName},
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        if (data.isNotEmpty) {
          setState(() {
            departmentContent = data.first['content'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching department info: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.departmentName,
          style: TextStyle(color: color, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        departmentContent,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
