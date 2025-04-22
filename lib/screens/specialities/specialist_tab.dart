import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/find_a_doctor/dept_doc_model.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_info.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';
import 'package:meditrina_01/util/routes.dart';

class SpecialistTab extends StatefulWidget {
  final String departmentName;

  const SpecialistTab({super.key, required this.departmentName});

  @override
  State<SpecialistTab> createState() => _SpecialistTabState();
}

class _SpecialistTabState extends State<SpecialistTab> {
  Dio dio = Dio();
  bool isLoading = true;
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );
  String departmentContent = "";
  Future<List<DocModel>>? _doctorsFuture;

  @override
  void initState() {
    super.initState();

    _doctorsFuture = fetchDepartmentDoctors(widget.departmentName);
  }

  Future<List<DocModel>> fetchDepartmentDoctors(String department) async {
    try {
      var response = await Dio().get(
        "https://meditrinainstitute.com/report_software/api/get_doctor.php",
        queryParameters: {"department": department},
      );

      if (response.statusCode == 200) {
        // 🔄 Parse directly into DoctorsListModel
        DoctorsListModel doctorsModel =
            DoctorsListModel.fromJson(response.data);

        if (doctorsModel.data.isNotEmpty) {
          setState(() {
            isLoading = false;
          });
        }

        return doctorsModel.data;
      } else {
        throw Exception("Failed to load doctors");
      }
    } catch (e) {
      setState(() => isLoading = false);
      throw Exception("Error fetching doctors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("No doctors available"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No doctors available"));
                      }

                      List<DocModel> doctors = snapshot.data!;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            itemCount: doctors.length,
                            shrinkWrap:
                                true, // ✅ Ensures ListView takes only needed space
                            physics:
                                NeverScrollableScrollPhysics(), // ✅ Disables ListView's scrolling
                            itemBuilder: (context, index) {
                              final doctor = doctors[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DoctorInfoScreen(doctor: doctor),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                doctor.doctorName,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: color),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                doctor.education,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700]),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                ],
              ),
            ),
          );
  }
}
