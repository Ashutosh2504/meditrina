import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/book_appointment/model_book_appointment.dart';
import 'package:meditrina_01/screens/specialities/book_appointment_tab.dart';
import 'package:meditrina_01/screens/specialities/overview_tab.dart';
import 'package:meditrina_01/screens/specialities/specialist_tab.dart';

class MySpecialitiesInfo extends StatefulWidget {
  const MySpecialitiesInfo({
    super.key,
    required this.department,
  });
  final Map<String, dynamic> department;

  @override
  State<MySpecialitiesInfo> createState() => _MySpecialitiesInfoState();
}

class _MySpecialitiesInfoState extends State<MySpecialitiesInfo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                text: widget.department['title'] ?? 'Speciality Info',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 8, 164, 196),
          bottom: const TabBar(
            tabs: [
              Tab(child: FittedBox(child: Text('Overview'))),
              Tab(child: FittedBox(child: Text('Specialist'))),
              Tab(child: FittedBox(child: Text('Book Appointment'))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OverviewTab(department: widget.department),
            SpecialistTab(
                departmentName:
                    widget.department['title']), // assuming 'id' key exists
            BookAppointmentTab(
              department: widget.department['title'],
              doctors: [],
            ),
          ],
        ),
      ),
    );
  }
}
