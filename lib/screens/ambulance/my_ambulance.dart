import 'package:flutter/material.dart';

class MyAmbulance extends StatefulWidget {
  const MyAmbulance({super.key});

  @override
  State<MyAmbulance> createState() => _MyAmbulanceState();
}

class _MyAmbulanceState extends State<MyAmbulance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Ambulance")),
    );
  }
}
