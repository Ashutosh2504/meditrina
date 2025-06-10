import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/affiliations/affiliations.dart';
import 'package:meditrina_01/screens/book_appointment/book_appointment.dart';
import 'package:meditrina_01/screens/contact_us/contact_us.dart';
import 'package:meditrina_01/screens/feedback/feedback.dart';
import 'package:meditrina_01/screens/gallery/gallery_model.dart';
import 'package:meditrina_01/screens/home/my_home.dart';
import 'package:meditrina_01/screens/homecare_assistance/homecare_assistance.dart';
import 'package:meditrina_01/screens/medical_tourism/medical_tourism.dart';
import 'package:meditrina_01/screens/medical_tourism/medical_tourism_model.dart';
import 'package:meditrina_01/screens/packages/packages.dart';
import 'package:meditrina_01/screens/patient_portal/patient_info.dart';
import 'package:meditrina_01/screens/patient_portal/patient_portal.dart';
import 'package:meditrina_01/screens/patient_portal/verify_otp.dart';
import 'package:meditrina_01/util/routes.dart';
import 'package:meditrina_01/util/secure_storage_service.dart';
import 'package:meditrina_01/util/webview.dart';
import 'package:http/http.dart' as http;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  GalleryModel? galleryModel;
  bool isGalleryLoading = true; // NEW

  @override
  void initState() {
    super.initState();
    loadGallery();
  }

  void loadGallery() async {
    final result = await fetchGallery();
    if (result != null) {
      setState(() {
        galleryModel = result;
        isGalleryLoading = false;
      });
    } else {
      setState(() {
        isGalleryLoading = false;
      });
    }
  }

  Future<GalleryModel?> fetchGallery() async {
    const url =
        'https://meditrinainstitute.com/report_software/api/get_gallery.php'; // replace with your actual URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return GalleryModel.fromJson(jsonBody);
      } else {
        print("Error: Server responded with ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching gallery: $e");
    }

    return null;
  }

  // 🏷️ Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // 📌 Drawer Item Widget
  Widget _buildDrawerItem(String icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        icon,
        height: 20,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/navv.jpg"), // Replace with your image path
                fit: BoxFit
                    .cover, // Ensures the image covers the entire background
              ),
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   radius: 30,
                //   child: Icon(Icons.person, size: 40, color: Colors.blue),
                // ),
                SizedBox(height: 10),
                // Text("User Name",
                //     style: TextStyle(color: Colors.white, fontSize: 18)),
                // Text("user@example.com",
                //     style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          ListTile(
            leading: Image.asset(
              "assets/images/k5.png",
              height: 20,
            ),
            title: Text("Home"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/images/user.png",
              height: 20,
            ),
            title: Text("Patient Portal"),
            onTap: () async {
              final storage = SecureStorageService();
              String? storedPatientInfo =
                  await storage.readSecureData("patientInfo");

              if (storedPatientInfo != null && storedPatientInfo.isNotEmpty) {
                try {
                  final Map<String, dynamic> jsonData =
                      jsonDecode(storedPatientInfo);
                  final PatientInfo patientInfo =
                      PatientInfo.fromJson(jsonData);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyOtp(patientInfo: patientInfo),
                    ),
                  );
                } catch (e) {
                  // In case of corrupted data, fallback to login
                  Navigator.pushReplacementNamed(
                      context, MyRoutes.patients_portal);
                }
              } else {
                Navigator.pushReplacementNamed(
                    context, MyRoutes.patients_portal);
              }
            },
          ),
//  () async {
//             final storage = SecureStorageService();
//             String? phone = await storage.getPhone();

//             if (phone != null && phone.isNotEmpty) {
//               Navigator.pushNamed(context, MyRoutes.verify_otp);
//             } else {
//               Navigator.pushReplacementNamed(context, MyRoutes.patients_portal);
//             }
//           }),

          ListTile(
              leading: Image.asset(
                "assets/images/dd5.png",
                height: 20,
              ),
              title: Text("Plan Your Visit"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyBookAppointment(
                            selectedDepartment: '',
                            doctorList: [],
                          )),
                );
              }),
          ListTile(
            leading: Image.asset(
              "assets/images/ankk2.png",
              height: 20,
            ),
            title: Text("Contact Us"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyContactUs()),
              );
            },
          ),
          // 🏠 Home Section
          _buildSectionHeader("Services"),
          _buildDrawerItem("assets/images/ankk.png", "Online Pathalogy", () {
            Navigator.pushReplacementNamed(context, MyRoutes.online_pathalogy);
          }),

          _buildDrawerItem("assets/images/group.png", "Service Providers", () {
            Navigator.pushReplacementNamed(context, MyRoutes.service_providers);
          }),
          _buildDrawerItem("assets/images/user.png", "Homecare Assistance", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeCareAssistanceScreen()),
            );
          }),
          // _buildDrawerItem(
          //     "assets/images/user.png", "Homecare Assistance", () {}),
          _buildDrawerItem("assets/images/user.png", "Promotions & Packages",
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PackagesScreen()),
            );
          }),
          _buildDrawerItem("assets/images/user.png", "Medical Tourism", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MedicalTourismScreen()),
            );
          }),
          isGalleryLoading
              ? ListTile(
                  leading: Image.asset("assets/images/user.png", height: 20),
                  title: Row(
                    children: [
                      Text("Gallery"),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ),
                  onTap: null, // Disabled
                )
              : _buildDrawerItem("assets/images/user.png", "Gallery", () {
                  if (galleryModel != null && galleryModel!.data.isNotEmpty) {
                    final url = galleryModel!.data.first.galleryUrl;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebviewComponent(
                          webviewUrl: url,
                          title: "Gallery",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gallery is unavailable.")),
                    );
                  }
                }),

          _buildDrawerItem("assets/images/user.png", "Patient Rights", () {
            Navigator.pushReplacementNamed(context, MyRoutes.patients_rights);
          }),
          // _buildDrawerItem("assets/images/user.png", "Health Tips", () {}),
          _buildDrawerItem("assets/images/user.png", "Affiliations", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AffiliationsScreen()),
            );
          }),
          // _buildDrawerItem("assets/images/user.png", "Pay Online", () {}),
          _buildDrawerItem("assets/images/user.png", "Feedback Form", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackScreen()),
            );
          }),
        ],
      ),
    );
  }
}
