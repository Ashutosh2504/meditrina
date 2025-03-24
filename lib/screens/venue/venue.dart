import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MyVenue extends StatelessWidget {
  const MyVenue({super.key});
  Future getMaps() {
    return MapsLauncher.launchCoordinates(
        21.1458, 79.0882, 'Meditrina Hospital');
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24, // ✅ Positioning from bottom
      child: ElevatedButton.icon(
        onPressed: () {
          getMaps();
          print("Navigate clicked!"); // ✅ Action for button
        },
        icon: Icon(Icons.directions),
        label: Text("Directions"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // ✅ Button color
          foregroundColor: Colors.blue, // ✅ Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
