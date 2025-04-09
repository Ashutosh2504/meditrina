import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/home/my_home.dart';
import 'package:meditrina_01/util/routes.dart';
import 'package:meditrina_01/util/secure_storage_service.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  final Color titleColor = Color.fromARGB(255, 1, 144, 159);

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _checkLoginStatus();
  // }

  // Future<void> _checkLoginStatus() async {
  //   final storage = SecureStorageService();
  //   final phone = await storage.getPhone();

  //   if (phone != null) {
  //     Timer(Duration(seconds: 3), () {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => MyHomePage(),
  //           ));
  //     });
  //   } else {
  //     // Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
  //     Timer(Duration(seconds: 3), () {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => MyHomePage(),
  //           ));
  //     }); // or login
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Image.asset(
        "assets/images/screen.png",
        fit: screenWidth > 500 ? BoxFit.cover : BoxFit.fill,
        height: screenHeight,
        width: screenWidth,
        // scale: 1.6,
        //alignment: Alignment.center,
      ),
    );
  }
}
