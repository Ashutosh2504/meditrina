import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';

// Assuming your model is like this:
// update this import path

class DoctorProfileScreen extends StatelessWidget {
  final DocModel doctor;

  const DoctorProfileScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(255, 8, 164, 196);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          doctor.doctorName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (doctor.docImage.trim().isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    doctor.docImage,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 10),
            doctor.profile.trim().isNotEmpty
                ? Html(data: doctor.profile, style: {
                    "body": Style(
                        textAlign: TextAlign.justify,
                        fontStyle: FontStyle.normal // Justify the text content
                        ),
                  })
                : Text(
                    "No profile information available.",
                    style: TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
