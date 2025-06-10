import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meditrina_01/screens/online_pathalogy/online_pathalogy_model.dart';
import 'dart:convert';

import 'package:meditrina_01/screens/online_pathalogy/pathalogy_payment_model.dart';
import 'package:meditrina_01/util/razorpay_gateway.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PathologyPaymentDetailsScreen extends StatefulWidget {
  final List<OnlinePathalogy> cartItems;

  const PathologyPaymentDetailsScreen({super.key, required this.cartItems});

  @override
  State<PathologyPaymentDetailsScreen> createState() =>
      _PathologyPaymentDetailsScreenState();
}

class _PathologyPaymentDetailsScreenState
    extends State<PathologyPaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;
  bool _isLoading = false;

  final Color color = const Color.fromARGB(255, 8, 164, 196);

  double get totalAmount => widget.cartItems
      .fold(0, (sum, item) => sum + double.tryParse(item.fees)!.toDouble());

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: color),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: Icon(icon, color: color),
    );
  }

  Future<void> _selectPickupDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _pickupDate = picked);
  }

  Future<void> _selectPickupTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _pickupTime = picked);
  }

  Future<void> _submitPayment(PathalogyPaymentModel payment) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://meditrinainstitute.com/report_software/api/post_online_pathology.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payment.toJson()),
      );

      final res = json.decode(response.body);

      if (response.statusCode == 200 &&
          (res['status'] == true || res['status'] == "true")) {
        _showSnackBar(
            "Payment ${payment.status == 'success' ? "Successful" : payment.status}");
        if (payment.status == "success") Navigator.pop(context, true);
      } else {
        _showSnackBar(
            "Payment ${payment.status} failed to record: ${res['message']}");
      }
    } catch (e) {
      _showSnackBar("Failed to record payment: $e");
    }
  }

  Future<void> _makePayment() async {
    if (!_formKey.currentState!.validate()) return;

    String tnxId = DateTime.now().millisecondsSinceEpoch.toString();
    String formattedTime = _pickupTime != null
        ? _pickupTime!.format(context)
        : TimeOfDay.now().format(context);

    PathalogyPaymentModel baseModel = PathalogyPaymentModel(
      tnxId: tnxId,
      patientName: _nameController.text,
      email: _emailController.text,
      mobile: _mobileController.text,
      testsName: widget.cartItems.map((e) => e.testName).toList(),
      amount: totalAmount.toStringAsFixed(2),
      status: "pending", // Initial
      date: _pickupDate ?? DateTime.now(),
      time: formattedTime,
      address: _addressController.text,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RazorpayPaymentScreen(
          amount: totalAmount.toInt(),
          userName: _nameController.text,
          contact: _mobileController.text,
          email: _emailController.text,
          onPaymentSuccess: (PaymentSuccessResponse res) {
            _submitPayment(baseModel.copyWith(status: 'success'));
          },
          onPaymentError: (PaymentFailureResponse res) {
            _submitPayment(baseModel.copyWith(status: 'failed'));
          },
          onExternalWallet: (ExternalWalletResponse res) {
            _submitPayment(baseModel.copyWith(status: 'external_wallet'));
          },
        ),
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patient Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      _buildInputDecoration("Patient Name", Icons.person),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mobileController,
                  decoration: _buildInputDecoration("Mobile", Icons.phone),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (val) => val == null || val.length != 10
                      ? "Enter valid mobile"
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: _buildInputDecoration("Email", Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || !val.contains("@")
                      ? "Enter valid email"
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: _buildInputDecoration("Address", Icons.home),
                  validator: (val) =>
                      val == null || val.isEmpty ? "Enter address" : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectPickupDate,
                  child: InputDecorator(
                    decoration: _buildInputDecoration(
                        "Date of Pickup", Icons.calendar_today),
                    child: Text(
                      _pickupDate == null
                          ? "Select date"
                          : "${_pickupDate!.day}/${_pickupDate!.month}/${_pickupDate!.year}",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selectPickupTime,
                  child: InputDecorator(
                    decoration: _buildInputDecoration(
                        "Time of Pickup", Icons.access_time),
                    child: Text(
                      _pickupTime == null
                          ? "Select time"
                          : _pickupTime!.format(context),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _makePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white)
                      : const Text(
                          "Proceed to Pay",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
