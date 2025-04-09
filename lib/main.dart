import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/ambulance/my_ambulance.dart';
import 'package:meditrina_01/screens/book_appointment/book_appointment.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_info.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';
import 'package:meditrina_01/screens/home/my_home.dart';
import 'package:meditrina_01/screens/online_pathalogy/online_pathalogy.dart';
import 'package:meditrina_01/screens/patient_portal/patient_portal.dart';
import 'package:meditrina_01/screens/patient_portal/verify_otp.dart';
import 'package:meditrina_01/screens/patients_rights/patients_right.dart';
import 'package:meditrina_01/screens/service_providers/service_providers.dart';
import 'package:meditrina_01/screens/splash_screen/splash_screen.dart';
import 'package:meditrina_01/util/routes.dart';
import 'package:meditrina_01/util/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = SecureStorageService();
  final phone = await storage.getPhone();

  runApp(MyApp(initialPhone: phone));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String? initialPhone;
  // const MyApp({super.key});

  MyApp({required this.initialPhone});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditrina',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final args = settings.arguments; // Get arguments dynamically

        if (settings.name == MyRoutes.book_appointment) {
          final args =
              settings.arguments as Map<String, dynamic>?; // Handle null case
          return MaterialPageRoute(
            builder: (context) => MyBookAppointment(
              doctorList: <DocModel>[],
              selectedDepartment: args?['departmentName'] ?? '',
            ),
          );
        } else if (settings.name == MyRoutes.doctor_info) {
          if (args is DocModel) {
            return MaterialPageRoute(
              builder: (context) => DoctorInfoScreen(doctor: args),
            );
          }
        } else if (settings.name == MyRoutes.verify_otp) {
          if (args is Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (context) => VerifyOtp(
                patientInfo: args['patientInfo'] ?? '',
              ),
            );
          }
        }

        return null; // Return null if no route matches
      },
      routes: {
        "/": (context) => MySplashScreen(),
        MyRoutes.homeRoute: (context) => MyHomePage(),
        MyRoutes.ambulance: (context) => MyAmbulance(),
        MyRoutes.online_pathalogy: (context) => MyOnlinePathalogy(),
        MyRoutes.service_providers: (context) => ServiceProviders(),
        MyRoutes.patients_portal: (context) => PatientPortal(),
        MyRoutes.patients_rights: (context) => PatientRightsScreen(),
       
      },
    );
  }
}
