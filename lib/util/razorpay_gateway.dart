import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditrina_01/util/payment_success.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:dio/dio.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  final int amount; // in INR
  final String userName;
  final String contact;
  final String email;
  final void Function(PaymentSuccessResponse) onPaymentSuccess;
  final void Function(PaymentFailureResponse)? onPaymentError;
  final void Function(ExternalWalletResponse)? onExternalWallet;

  const RazorpayPaymentScreen({
    super.key,
    required this.amount,
    required this.userName,
    required this.contact,
    required this.email,
    required this.onPaymentSuccess,
    this.onPaymentError,
    this.onExternalWallet,
  });

  @override
  State<RazorpayPaymentScreen> createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;
  bool _isLoading = false;
  final Dio _dio = Dio();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _startPayment() async {
    setState(() => _isLoading = true);

    try {
      final response = await _dio.post(
        'https://meditrinainstitute.com/report_software/api/razorpay_create_order.php', // ✅ Replace with your actual URL
        data: jsonEncode({'amount': widget.amount}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final data = jsonDecode(response.data);

      if (data['success']) {
        String orderId = data['orderId'];

        var options = {
          'key': 'rzp_live_ArfemYrX5BiGIA',
          'amount': widget.amount * 100,
          'currency': 'INR',
          'name': 'Meditrina Institute',
          'description': 'Payment for Booking',
          'order_id': orderId,
          'prefill': {
            'contact': widget.contact,
            'email': widget.email,
            'name': widget.userName,
          },
          'theme': {
            'color': '#08A4C4',
          }
        };

        _razorpay.open(options);
      } else {
        _showError(data['message'] ?? 'Failed to create Razorpay order');
      }
    } on DioException catch (e) {
      _showError('Network error: ${e.message}');
      print(e.message);
    } catch (e) {
      _showError('Unexpected error: $e');
      print(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    // );
    // Navigator.pop(context, true);

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
    // );
    widget.onPaymentSuccess(response);
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (widget.onPaymentError != null) {
      widget.onPaymentError!(response);
    } else {
      _showError("Payment Failed: ${response.message}");
    }
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (widget.onExternalWallet != null) {
      widget.onExternalWallet!(response);
    } else {
      _showError("Wallet Selected: ${response.walletName}");
    }
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: color,
          title: const Text(
            "Razorpay Payment",
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Amount to Pay: ₹${widget.amount}",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color, // your preferred blue color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: color, fontSize: 13),
                          "Please click on above Proceed to Payment button to book the appointment"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
