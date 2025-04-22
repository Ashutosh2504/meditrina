// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/book_appointment/book_appointment.dart';

import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';
import 'package:url_launcher/url_launcher.dart'; // Import your model

class DoctorInfoScreen extends StatefulWidget {
  final DocModel doctor;

  DoctorInfoScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
  Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Doctor's Information", style: TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
      body: Container(
        height: double.infinity,
        color: color,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.00),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Doctor Image (Rectangular)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.doctor.docImage,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Doctor Name
                    Center(
                      child: Text(
                        widget.doctor.doctorName,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Department
                    Text(
                      widget.doctor.departmentName,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 16),

                    // Education
                    Text(
                      "${widget.doctor.education}",
                      style: TextStyle(fontSize: 15),
                    ),

                    // Specialization
                    Text(
                      " ${widget.doctor.speciality}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    // Email with Icon
                    InkWell(
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: widget.doctor.email,
                        );
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not open mail app')),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.mail, color: color),
                          const SizedBox(width: 10),
                          Text(
                            widget.doctor.email,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Mobile with Icon
                    InkWell(
                      onTap: () async {
                        final Uri phoneUri =
                            Uri(scheme: 'tel', path: widget.doctor.mobile);
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch dialer')),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.phone, color: color),
                          const SizedBox(width: 10),
                          Text(
                            widget.doctor.mobile,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle View Profile
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("View Profile"),
                                      content: Text(
                                          "This is the profile of Dr. ${widget.doctor.doctorName}."),
                                      actions: [
                                        TextButton(
                                          child: Text("Close"),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "View Profile",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyBookAppointment(
                                        selectedDepartment:
                                            widget.doctor.departmentName,
                                        doctorList: [widget.doctor],
                                      ),
                                    ),
                                  );
                                },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Book Appointment",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
