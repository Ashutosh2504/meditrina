import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/patient_portal/patient_info.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key, required this.patientInfo});
  final PatientInfo patientInfo;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  Map<String, String> reportMap = {}; // Stores { report_name: report_file }
  bool isLoadingTests = true; // Loader only for tests

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  /// Fetch Reports API
  /// Fetch Reports API
  Future<void> fetchReports() async {
    final String apiUrl =
        "https://meditrinainstitute.com/report_software/api/get_report.php?patient_id=${widget.patientInfo.id}";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Convert to { report_name: report_file } mapping
          Map<String, String> fetchedReports = {};
          for (var report in data['data']) {
            fetchedReports[report['report_name']] = report['report_file'];
          }
          setState(() {
            reportMap = fetchedReports;
          });
        }
      }
    } catch (e) {
      print("Error fetching reports: $e");
    } finally {
      setState(() {
        isLoadingTests = false; // Stop loader after fetching
      });
    }
  }

  /// Open Report in Browser
  void _openReport(String reportUrl) async {
    final Uri url = Uri.parse(reportUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open report: $reportUrl");
    }
  }

  // await Navigator.of(context).push(
  //                     MaterialPageRoute(
  //                       builder: (ctxt) => WebviewComponent(
  //                           title: "Survey",
  //                           webviewUrl:
  //                               "https://globalhealth-forum.com/event_app/survey.php?user_id=${user_id}&email_id=${user_email}"),
  //                     ),

  /// **Creates Patient Info Table**
  Widget _buildInfoTable() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Table(
          columnWidths: const {0: FractionColumnWidth(0.4)}, // First column 40%
          children: [
            _buildTableRow('Name', widget.patientInfo.fullName),
            _buildTableRow('Mobile', widget.patientInfo.mobileNumber),
            _buildTableRow('Age', widget.patientInfo.age),
            _buildTableRow('Gender', widget.patientInfo.gender),
            _buildTableRow(
                'Consulting Doctor', widget.patientInfo.consultingDoctor),
            _buildTableRow('Registered Date', widget.patientInfo.date),
          ],
        ),
      ),
    );
  }

  /// **Creates List of Tests with Eye Icon**
  Widget _buildTestList(List<String> tests) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: tests.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          String testName = tests[index].trim();
          bool hasReport = reportMap.containsKey(testName);
          String? reportUrl = hasReport ? reportMap[testName] : null;

          return ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.blue),
            title: Text(testName, style: TextStyle(fontSize: 16)),
            trailing: IconButton(
              icon: Icon(hasReport ? Icons.visibility : Icons.visibility_off,
                  color: hasReport ? Colors.green : Colors.grey),
              onPressed: hasReport ? () => _openReport(reportUrl!) : null,
            ),
          );
        },
      ),
    );
  }

  /// **Builds Table for Patient Info**
  Widget _buildTable(List<TableRow> rows) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FractionColumnWidth(0.4),
        1: FractionColumnWidth(0.6),
      },
      children: rows,
    );
  }

  /// **Creates a Single Row for Table**
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> tests = widget.patientInfo.testPrescribed.split('|');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Portal',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Welcome Section**
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

            /// **Personal Details Section**
            _buildSectionTitle('Personal Details'),
            _buildInfoTable(),

            /// **Tests Prescribed Section with Loader**
            _buildSectionTitle('Tests Prescribed'),
            isLoadingTests
                ? Center(
                    child: CircularProgressIndicator()) // Loader for tests only
                : _buildTestList(tests),
          ],
        ),
      ),
    );
  }

  /// **Builds Section Title**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
