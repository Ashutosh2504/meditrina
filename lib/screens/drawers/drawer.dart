import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/contact_us/contact_us.dart';
import 'package:meditrina_01/screens/patient_portal/patient_portal.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
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
            decoration: BoxDecoration(color: Colors.blue),
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
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Patient Portal"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientPortal()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Plan Your Visit"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
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
          _buildDrawerItem(Icons.dashboard, "Online Pathalogy", () {}),
          _buildDrawerItem(Icons.notifications, "Service Providers", () {}),
          _buildDrawerItem(Icons.notifications, "Homecare Assistance", () {}),
          _buildDrawerItem(Icons.notifications, "Homecare Assistance", () {}),
          _buildDrawerItem(Icons.notifications, "Promotions & Packages", () {}),
          _buildDrawerItem(Icons.notifications, "Medical Tourism", () {}),
          _buildDrawerItem(Icons.notifications, "Gallery", () {}),
          _buildDrawerItem(Icons.notifications, "Patient Rights", () {}),
          _buildDrawerItem(Icons.notifications, "Health Tips", () {}),
          _buildDrawerItem(Icons.notifications, "Affiliations", () {}),
          _buildDrawerItem(Icons.notifications, "Pay Online", () {}),
          _buildDrawerItem(Icons.notifications, "Feedback Form", () {}),
        ],
      ),
    );
  }
}
