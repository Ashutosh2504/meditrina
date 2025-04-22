import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class OverviewTab extends StatefulWidget {
  final Map<String, dynamic> department;

  const OverviewTab({super.key, required this.department});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
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
        queryParameters: {'department': widget.department['title']},
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.department['icon'],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Html(
            data: departmentContent ?? "No description available.",
            // style: TextStyle(fontSize: 16),
            // textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
