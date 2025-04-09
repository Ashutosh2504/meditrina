// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

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
  Color color = const Color.fromARGB(255, 8, 164, 196);
  bool isPaying = false;
  int timerSeconds = 180; // 10 mins
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
    _razorpay = Razorpay();

    // Event Listeners for Payment
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds == 0) {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Session expired. Please try again.")),
        );
        Navigator.pop(context);
      } else {
        setState(() => timerSeconds--);
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    _razorpay.clear(); // Clear all event listeners
    super.dispose();
  }

  // Function to start the payment
  void startPayment() {
    var options = {
      'key': 'rzp_live_ArfemYrX5BiGIA', // Replace with your Razorpay API Key
      // 'amount': widget.amount, // Amount in paise (₹500.00)
      'amount': 1, // Amount in paise (₹500.00)
      'name': 'MediTrina Institute',
      'description': 'Appointment Booking',
      'prefill': {
        'contact': '8459234792', // Pre-filled phone number
        'email': 'ashup953@gmail.com' // Pre-filled email
      },
      'theme': {
        'color': '#0069E1' // Razorpay UI color
      },
      'payment_capture': 1,
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
    return WillPopScope(
      onWillPop: () async {
        bool shouldLeave = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Cancel Payment?"),
            content: const Text(
                "Are you sure you want to cancel the payment and go back?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Stay
                child: const Text("Stay"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Leave
                child: const Text("Yes, Cancel"),
              ),
            ],
          ),
        );
        return shouldLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Secure Payment"),
          backgroundColor: const Color(0xFF0069E1),
          leading: const Icon(Icons.lock, color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Please complete your payment within:",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Text(
                formatTime(timerSeconds),
                style: const TextStyle(fontSize: 20, color: Colors.red),
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Amount:", style: TextStyle(fontSize: 18)),
                  Text(
                    "₹${widget.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: isPaying
                      ? null
                      : () {
                          setState(() => isPaying = true);
                          startPayment();
                        },
                  child: Text(
                    "Proceed to Pay ₹${widget.amount.toStringAsFixed(2)}",
                    style: TextStyle(color: color),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


//event -> order.paid