// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  const PaymentScreen({
    super.key,
    required this.amount,
  });
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Event Listeners for Payment
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear all event listeners
    super.dispose();
  }

  // Function to start the payment
  void startPayment() {
    var options = {
      'key': 'rzp_test_YourKeyHere', // Replace with your Razorpay API Key
      'amount': widget.amount, // Amount in paise (₹500.00)
      'name': 'MediTrina Institute',
      'description': 'Appointment Booking',
      'prefill': {
        'contact': '9876543210', // Pre-filled phone number
        'email': 'test@example.com' // Pre-filled email
      },
      'theme': {
        'color': '#0069E1' // Razorpay UI color
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Payment Success Handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
    print("Payment Successful: ${response.paymentId}");
  }

  // Payment Failure Handler
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
    print("Payment Failed: ${response.code} - ${response.message}");
  }

  // External Wallet Handler
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External Wallet Selected: ${response.walletName}")),
    );
    print("External Wallet Selected: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Appointment"),
        backgroundColor: Color(0xFF0069E1), // App bar color
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: startPayment,
          child: Text("Pay Now"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0069E1),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
