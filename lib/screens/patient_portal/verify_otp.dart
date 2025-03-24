import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Portal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, [Patient Name]',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            _buildInfoRow('Name:', 'John Doe'),
            _buildInfoRow('Mobile:', '9876543210'),
            _buildInfoRow('Email:', 'johndoe@example.com'),
            _buildInfoRow('Address:', '123 Main Street, City, Country'),
            SizedBox(height: 16),
            Text('Appointments & Reports',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Example data count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Appointment on: 25-03-2025'),
                    subtitle:
                        Text('Doctor: Dr. Smith | Department: Cardiology'),
                    trailing: Icon(Icons.picture_as_pdf),
                    onTap: () => print('Open Report $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
