import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';

class PatientRightsScreen extends StatelessWidget {
  final Color primaryColor = const Color.fromARGB(255, 8, 164, 196);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Patient Rights & Responsibilities"),
        ),
        body: Column(
          children: [
            /// ✅ Image above TabBar
            Image.asset(
              'assets/images/serrv.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            /// ✅ TabBar below image
            Material(
              color: Colors.white,
              child: TabBar(
                labelColor: primaryColor,
                unselectedLabelColor: primaryColor,
                indicatorColor: primaryColor,
                tabs: [
                  Tab(text: "Patient Rights"),
                  Tab(text: "Responsibilities"),
                ],
              ),
            ),

            /// ✅ Tab content
            Expanded(
              child: TabBarView(
                children: [
                  /// Tab 1: Patient Rights
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildPoint("1) Right to Respect and Dignity", [
                          "Every patient has the right to be treated with respect, consideration, and dignity.",
                          "Patients’ personal values and beliefs will be honored.",
                          "Confidentiality and privacy will be maintained at all times.",
                        ]),
                        buildPoint("2) Right to Information", [
                          "Patients have the right to receive complete and current information about their diagnosis, treatment, and prognosis in understandable language.",
                          "They are entitled to know the identity of healthcare providers involved in their care.",
                        ]),
                        buildPoint("3) Right to Consent", [
                          "Patients have the right to make informed decisions about their treatment.",
                          "They must be informed about risks, benefits, and alternatives before giving consent.",
                        ]),
                        buildPoint("4) Right to Safety", [
                          "Patients have the right to receive care in a safe and secure environment.",
                          "They should be protected from any abuse, neglect, or harassment.",
                        ]),
                      ],
                    ),
                  ),

                  /// Tab 2: Responsibilities
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildPoint("1) Providing Information", [
                          "Patients are responsible for providing accurate and complete information about their health, including past illnesses and treatments.",
                        ]),
                        buildPoint("2) Following Instructions", [
                          "Patients should follow the treatment plan recommended by their healthcare provider.",
                          "They are responsible for informing providers if they do not understand the instructions.",
                        ]),
                        buildPoint("3) Respecting Others", [
                          "Patients must show consideration for the rights of other patients and staff.",
                          "They should avoid making noise or behaving disruptively.",
                        ]),
                        buildPoint("4) Fulfilling Financial Obligations", [
                          "Patients are responsible for promptly fulfilling financial commitments related to their healthcare.",
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget for each bold heading and list of details
  Widget buildPoint(String heading, List<String> texts) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          ...texts.map(
            (text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                " $text",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
