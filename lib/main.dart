import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:meditrina_01/screens/ambulance/my_ambulance.dart';
import 'package:meditrina_01/screens/book_appointment/book_appointment.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_info.dart';
import 'package:meditrina_01/screens/home/my_home.dart';
import 'package:meditrina_01/screens/online_pathalogy/online_pathalogy.dart';
import 'package:meditrina_01/screens/patient_portal/verify_otp.dart';
import 'package:meditrina_01/screens/splash_screen/splash_screen.dart';
import 'package:meditrina_01/util/routes.dart';
import 'package:meditrina_01/widgets/my_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Meditrina',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const MyHomePage(),

        onGenerateRoute: (settings) {
          if (settings.name == MyRoutes.book_appointment) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => MyBookAppointment(
                selectedDoctor: args['doctorName'],
                selectedDepartment: args['departmentName'],
              ),
            );
          } else if (settings.name == MyRoutes.doctor_info) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => MyDoctorInfo(
                selectedDoctor: args['doctorName'],
                selectedDepartment: args['departmentName'],
              ),
            );
          } else if (settings.name == MyRoutes.verify_otp) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => VerifyOtp(
                patientInfo: args['patientInfo'],
              ),
            );
          }
          return null;
        },
        routes: {
          "/": (context) => MySplashScreen(),
          // "/": (context) => const MyHomePage(),
          MyRoutes.homeRoute: (context) => MyHomePage(),
          MyRoutes.ambulance: (context) => MyAmbulance(),
          MyRoutes.online_pathalogy: (context) => OnlinePathalogy(),
          // MyRoutes.verify_otp: (context) => VerifyOtp(),
          //  MyRoutes.homeRoute: (context) => MyHome(),
        });
  }
}
