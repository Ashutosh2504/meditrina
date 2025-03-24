import 'package:flutter/material.dart';

class MyDoctorInfo extends StatefulWidget {
  final String selectedDoctor;
  final String selectedDepartment;
  const MyDoctorInfo({
    super.key,
    required this.selectedDoctor,
    required this.selectedDepartment,
  });

  @override
  State<MyDoctorInfo> createState() => _MyDoctorInfoState();
}

class _MyDoctorInfoState extends State<MyDoctorInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedDoctor),
      ),
    );
  }
}
