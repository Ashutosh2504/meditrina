import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/book_appointment/book_appointment.dart';
import 'package:meditrina_01/screens/find_a_doctor/dept_doc_model.dart'; // this should define DocModel
import 'package:meditrina_01/screens/find_a_doctor/doctor_info.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';
import 'package:meditrina_01/util/routes.dart';

class DepartmentInfoScreen extends StatefulWidget {
  final String departmentName;

  const DepartmentInfoScreen({super.key, required this.departmentName});

  @override
  State<DepartmentInfoScreen> createState() => _DepartmentInfoScreenState();
}

class _DepartmentInfoScreenState extends State<DepartmentInfoScreen> {
  Dio dio = Dio();
  bool isLoading = true;
  Color color = const Color.fromARGB(255, 8, 164, 196);
  String departmentContent = "";
  Future<List<DocModel>>? _doctorsFuture;

  @override
  void initState() {
    super.initState();
    fetchDepartmentInfo();
    _doctorsFuture = fetchDepartmentDoctors(widget.departmentName);
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

  Future<List<DocModel>> fetchDepartmentDoctors(String department) async {
    try {
      var response = await Dio().get(
        "https://meditrinainstitute.com/report_software/api/get_doctor.php",
        queryParameters: {"department": department},
      );

      if (response.statusCode == 200) {
        DoctorsListModel doctorsModel =
            DoctorsListModel.fromJson(response.data);
        return doctorsModel.data; // List<DocModel>
      } else {
        throw Exception("Failed to load doctors");
      }
    } catch (e) {
      throw Exception("Error fetching doctors: $e");
    }
  }

  List<DocModel> convertToDocModelList(List<DepartmentDoctors>? doctors) {
    return (doctors ?? [])
        .map((e) => DocModel(
              docId: e.docId,
              doctorName: e.doctorName,
              mobile: e.mobile,
              email: e.email,
              education: e.education,
              speciality: e.speciality,
              departmentName: e.departmentName,
              docImage: e.docImage,
              date: e.date,
            ))
        .toList();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<DocModel>>(
                      future: _doctorsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("No doctors available"));
                        }

                        List<DocModel> doctors = snapshot.data!;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              itemCount: doctors.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final doctor = doctors[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DoctorInfoScreen(
                                          doctor: doctor,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 1,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              doctor.docImage,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(Icons.person, size: 60),
                                            ),
                                          ),
                                          SizedBox(width: 18),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  doctor.doctorName,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: color),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  doctor.education,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700]),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${widget.departmentName}:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      departmentContent,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
