import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'package:meditrina_01/screens/patient_portal/verify_otp.dart';
import 'package:meditrina_01/util/api_service.dart';

class PatientPortal extends StatefulWidget {
  PatientPortal({super.key});

  @override
  State<PatientPortal> createState() => _PatientPortalState();
}

class _PatientPortalState extends State<PatientPortal> {
  final TextEditingController phoneController = TextEditingController();
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );
  String otpValue = "";
  String buttonText = "Get OTP";
  bool isOtpFieldVisible = false;
  bool isResendVisible = false;
  bool isLoading = false;
  Timer? _timer;
  int secondsRemaining = 45;
  final ApiService apiService = ApiService();

  void sendOtp() async {
    String phone = phoneController.text.trim();
    if (phone.length != 10) {
      showSnackbar("Enter a valid 10-digit number");
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await apiService.sendOtp(phone);
    if (success) {
      setState(() {
        isOtpFieldVisible = true;
        buttonText = "Verify OTP";
        isLoading = false;
        startTimer();
      });
    } else {
      showSnackbar("Failed to send OTP. Try again.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void verifyOtp() async {
    if (otpValue.length != 6) {
      showSnackbar("Enter a valid 6-digit OTP");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response =
        await apiService.verifyOtp(phoneController.text.trim(), otpValue);
    print(response?.toJson().toString());

    if (response != null) {
      // showSnackbar("OTP Verified! Navigating...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtp(patientInfo: response),
        ),
      );
    } else {
      showSnackbar("Invalid OTP. Please try again.");

      // Clear OTP fields when wrong OTP is entered
      setState(
        () {
          otpValue = "";
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void startTimer() {
    setState(() {
      secondsRemaining = 30;
      isResendVisible = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        setState(() {
          buttonText = "Resend OTP";
          isResendVisible = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/kk.jpg",
              width: 80, // Adjust size as needed
              height: 80,
              fit: BoxFit.contain,
            ),

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: color), // Default style
                  children: [
                    TextSpan(text: "Book an "),
                    TextSpan(
                      text: "Appointment",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Experience Quality",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " with us."),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Medical Registered Mobile Number",
                labelStyle: TextStyle(color: color),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey), // Default bottom line (gray)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: color, width: 1), // Blue bottom line when focused
                ),
                // border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.call, color: color), // Call icon
              ),
            ),

            SizedBox(height: 20),

            // OTP Input Field
            if (isOtpFieldVisible)
              OtpTextField(
                numberOfFields: 6,
                borderColor: color,
                showFieldAsBox: true,
                fieldWidth: 40,
                onCodeChanged: (String code) {
                  otpValue = code;
                },
                onSubmit: (String verificationCode) {
                  otpValue = verificationCode;
                },
              ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (buttonText == "Get OTP" ||
                            buttonText == "Resend OTP") {
                          sendOtp();
                        } else {
                          verifyOtp();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded edges
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(buttonText,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),

            // Resend OTP Timer with Message
            if (isOtpFieldVisible)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  isResendVisible
                      ? "Didn't receive OTP? Click 'Resend OTP'."
                      : "Wait $secondsRemaining sec to Resend OTP",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
