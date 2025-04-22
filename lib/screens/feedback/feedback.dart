import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/feedback/ipd_feedback.dart';
import 'package:meditrina_01/screens/feedback/opd_feedback.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Variable to store selected feedback type (OPD or IPD)
  String? selectedFeedback;

  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(255, 8, 164, 196);

    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback", style: TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image at the top with a responsive size
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/kk.jpg", // Your image path
                width: MediaQuery.of(context).size.width * 0.2, // Dynamic width
                height:
                    MediaQuery.of(context).size.width * 0.2, // Dynamic height
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 50),

            // OPD button with better padding and dynamic color change
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                // Change color if selected
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                minimumSize:
                    Size(double.infinity, 50), // Full width button with height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedFeedback = 'OPD';
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OPDFeedbackForm()),
                );
              },
              child: Text(
                "OPD Feedback Form",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16), // Slightly larger space

            // IPD button with similar styling
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color, // Change color if selected
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                minimumSize:
                    Size(double.infinity, 50), // Full width button with height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedFeedback = 'IPD';
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IPDFeedbackForm()),
                );
              },
              child: Text(
                "IPD Feedback Form",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
