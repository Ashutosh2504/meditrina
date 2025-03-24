import 'package:dio/dio.dart';
import 'package:meditrina_01/screens/book_appointment/model_book_appointment.dart';

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

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await dio.post(
        'https://meditrinainstitute.com/report_software/api/otp.php',
        data: {
          'otp': otp,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }
}
