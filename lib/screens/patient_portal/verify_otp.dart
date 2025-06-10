import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'package:meditrina_01/screens/patient_portal/patient_info.dart';
import 'package:meditrina_01/screens/patient_portal/reports_list.dart';
import 'package:meditrina_01/util/alerts.dart';
import 'package:meditrina_01/util/secure_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyOtp extends StatefulWidget {
  final PatientInfo patientInfo;

  const VerifyOtp({super.key, required this.patientInfo});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );
  List<ReportsModel> reportList = [];
  bool isLoadingTests = true;

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final String apiUrl =
        "https://meditrinainstitute.com/report_software/api/get_report.php?patient_id=${widget.patientInfo.id}";

    try {
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        final ReportsList reports = ReportsList.fromJson(response.data);

        if (reports.status == 'success') {
          final dateFormat = DateFormat("dd-MM-yyyy HH:mm");
          reports.data.sort((a, b) => dateFormat
              .parse(b.reportDate)
              .compareTo(dateFormat.parse(a.reportDate)));

          setState(() {
            reportList = reports.data;
          });
        }
      }
    } catch (e) {
      print("Error fetching reports: $e");
    } finally {
      setState(() {
        isLoadingTests = false;
      });
    }
  }

  void _openReport(String url) async {
    // Open PDF logic (e.g., with url_launcher or open_file packages)
    print("Opening report: $url");
    final Uri pdfUri = Uri.parse(url);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch PDF: $url';
    }
  }

  Widget _buildTestList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: reportList.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          final report = reportList[index];
          return ListTile(
            leading: const Icon(Icons.description, color: Colors.blue),
            title: Text(
              report.reportName,
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  softWrap: true,
                  "Referred by ${report.doctorName}",
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(height: 2), // a little spacing
                Text(
                  "Date: ${report.reportDate}",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                report.reportFile == null || report.reportFile.isEmpty
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: report.reportFile == null || report.reportFile.isEmpty
                    ? Colors.grey
                    : Colors.green,
              ),
              onPressed: report.reportFile == null || report.reportFile.isEmpty
                  ? () {
                      Alerts.showAlert(
                          false, context, "Report not yet available");
                    }
                  : () => _openReport(report.reportFile),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> tests = widget.patientInfo.testPrescribed.split('|');

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: color,
        title: const Text(
          'Patient Portal',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'logout') {
                _showLogoutConfirmation();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'Welcome ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    widget.patientInfo.fullName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPatientInfoCard(),
            _buildSectionTitle('Tests Prescribed'),
            isLoadingTests
                ? Center(child: CircularProgressIndicator())
                : _buildTestList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Personal Details:'),
            const SizedBox(height: 16),
            _infoRow(
              Icons.person,
              "Name",
              widget.patientInfo.fullName,
            ),
            const SizedBox(height: 16),
            _infoRow(Icons.cake, "Age", widget.patientInfo.age ?? "-"),
            const SizedBox(height: 16),
            _infoRow(Icons.wc, "Gender", widget.patientInfo.gender ?? "-"),
            const SizedBox(height: 16),
            _infoRow(
                Icons.phone, "Phone", widget.patientInfo.mobileNumber ?? "-"),
            const SizedBox(height: 16),
            _infoRow(Icons.person_add, "Consulting Doctor",
                widget.patientInfo.consultingDoctor),
            const SizedBox(height: 16),
            _infoRow(Icons.calendar_today, "Registered Date",
                widget.patientInfo.date ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Text(
          softWrap: true,
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you really want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
              onPressed: () async {
                // Handle logout logic
                final storage = SecureStorageService();
                await storage.clearPhone();
                await storage.deleteSecureData("patientInfo");
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
