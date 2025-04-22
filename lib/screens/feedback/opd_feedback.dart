import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class OPDFeedbackForm extends StatefulWidget {
  const OPDFeedbackForm({Key? key}) : super(key: key);

  @override
  State<OPDFeedbackForm> createState() => _OPDBookingFormState();
}

class _OPDBookingFormState extends State<OPDFeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  // Form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController visitDateController = TextEditingController();

  // Feedback fields (Radio buttons)
  String receptionPromptness = '';
  String departmentDirection = '';
  String consultantSatisfaction = '';
  String radiologyCourtesy = '';
  String radiologyExplanation = '';
  String nursingCourtesy = '';
  String dietCounseling = '';

  // Loading state for submit button
  bool isLoading = false;

  // Build Date Picker Field
  Widget buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)), // up to 1 year
          );

          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
            controller.text = formattedDate;
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            validator: (value) =>
                value == null || value.isEmpty ? 'Please select a date' : null,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ),
    );
  }

  // Build Radio Button Fields for Feedback
  Widget buildRadioButtonField(
      String label, String que, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text(que,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          Row(
            children: [
              Radio<String>(
                value: 'Excellent',
                groupValue: value,
                onChanged: (val) => onChanged(val!),
              ),
              Text('Excellent'),
              Radio<String>(
                value: 'Good',
                groupValue: value,
                onChanged: (val) => onChanged(val!),
              ),
              Text('Good'),
              Radio<String>(
                value: 'Poor',
                groupValue: value,
                onChanged: (val) => onChanged(val!),
              ),
              Text('Poor'),
            ],
          ),
        ],
      ),
    );
  }

  // Form submission
  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading
      });

      final formData = {
        'name': nameController.text.trim(),
        'address': addressController.text.trim(),
        'mobile': mobileController.text.trim(),
        'email': emailController.text.trim(),
        'visit_date': visitDateController.text.trim(),
        'reception_promptness': receptionPromptness,
        'department_direction': departmentDirection,
        'consultant_satisfaction': consultantSatisfaction,
        'radiology_courtesy': radiologyCourtesy,
        'radiology_explanation': radiologyExplanation,
        'nursing_courtesy': nursingCourtesy,
        'diet_counseling': dietCounseling,
      };

      try {
        var dio = Dio();
        final response = await dio.post(
          'https://meditrinainstitute.com/report_software/api/post_opd_feed.php', // Replace with actual API URL
          data: formData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully!')),
          );
          nameController.clear();
          addressController.clear();
          mobileController.clear();
          emailController.clear();
          visitDateController.clear();

          setState(() {
            receptionPromptness = '';
            departmentDirection = '';
            consultantSatisfaction = '';
            radiologyCourtesy = '';
            radiologyExplanation = '';
            nursingCourtesy = '';
            dietCounseling = '';
          });
        } else {
          throw Exception('Failed to submit form');
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed')),
        );
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book OPD Appointment",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              "assets/images/kk.jpg", // Replace with your logo
              width: 80, // Adjust size as needed
              height: 80,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 10,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(color: color),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color),
                  ),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField("Name", nameController),
                    buildTextField("Address", addressController),
                    buildTextField("Mobile", mobileController,
                        keyboardType: TextInputType.phone),
                    buildTextField("Email", emailController,
                        keyboardType: TextInputType.emailAddress),
                    buildDatePickerField("Visit Date", visitDateController),
                    Text(
                      "How would you rate us at the Front Office RECEPTION",
                      style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                    buildRadioButtonField(
                      "",
                      "1. Did the reception personnel attend you promptly?",
                      receptionPromptness,
                      (value) => setState(() {
                        receptionPromptness = value;
                      }),
                    ),
                    buildRadioButtonField(
                      "",
                      "2. Were you directed to various departments correctly?",
                      departmentDirection,
                      (value) => setState(() {
                        departmentDirection = value;
                      }),
                    ),
                    buildRadioButtonField(
                      "Consultant",
                      "3. How satisfied were you after meeting the consultant?",
                      consultantSatisfaction,
                      (value) => setState(() {
                        consultantSatisfaction = value;
                      }),
                    ),
                    buildRadioButtonField(
                      "Radiology ",
                      "4. Was the technician/radiographer courteous to you while perfoming the procedure?",
                      radiologyCourtesy,
                      (value) => setState(() {
                        radiologyCourtesy = value;
                      }),
                    ),
                    buildRadioButtonField(
                      "",
                      "5. Rate how was the procedure explained to you by the radiographer/technician. ",
                      radiologyExplanation,
                      (value) => setState(() {
                        radiologyExplanation = value;
                      }),
                    ),
                    buildRadioButtonField(
                      "Nursing ",
                      "6. Was the X-Ray, Echo, ECG, TMT technician/nursing staff in treatment room courteous to you",
                      nursingCourtesy,
                      (value) => setState(() {
                        nursingCourtesy = value;
                      }),
                    ),
                    buildRadioButtonField(
                      "Diet",
                      "7. How effective was the diet counselling?",
                      dietCounseling,
                      (value) => setState(() {
                        dietCounseling = value;
                      }),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      ),
                      onPressed: isLoading ? null : submitForm,
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text("Submit",
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Text Fields
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
