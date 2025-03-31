import 'package:dio/dio.dart';
import 'package:meditrina_01/screens/book_appointment/model_book_appointment.dart';
import 'package:meditrina_01/screens/patient_portal/patient_info.dart';

class ApiService {
  final Dio dio = Dio();
  final String baseUrl =
      "https://meditrinainstitute.com"; // Replace with actual API base URL

  Future<bool> sendOtp(String mobileNumber) async {
    try {
      Response response = await dio.post(
        'https://meditrinainstitute.com/report_software/api/login.php',
        data: {
          'mobile': mobileNumber,
        },
      );

      if (response.statusCode == 200) {
        print(response);
        return true;
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
    return false;
  }

  Future<PatientInfo?> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await dio.post(
        'https://meditrinainstitute.com/report_software/api/otp.php',
        data: {
          'otp': otp,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data.containsKey("user")) {
          return PatientInfo.fromJson(data["user"]);
        } else {
          print("Unexpected response format: $data");
          return null;
        }
      } else {
        print("Failed to verify OTP. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return null;
    }
  }
}
