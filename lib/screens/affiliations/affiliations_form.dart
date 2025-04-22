import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AffiliationsForm extends StatefulWidget {
  const AffiliationsForm({super.key});

  @override
  State<AffiliationsForm> createState() => _AffiliationsFormState();
}

class _AffiliationsFormState extends State<AffiliationsForm> {
  final _formKey = GlobalKey<FormState>();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  // Form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController preferredTimeController = TextEditingController();
  final TextEditingController referredByDoctorController =
      TextEditingController();

  String gender = 'Male'; // default

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

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'name': nameController.text.trim(),
        'age': ageController.text.trim(),
        'contact_number': contactController.text.trim(),
        'gender': gender,
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'preferred_time': preferredTimeController.text.trim(),
        'referred_by_doctor': referredByDoctorController.text.trim()
      };

      try {
        var dio = Dio();
        final response = await dio.post(
          'https://your_api_endpoint.com/submit_affiliations_booking.php',
          data: formData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully!')),
          );
        } else {
          throw Exception('Failed to submit form');
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Package",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              "assets/images/kk.jpg",
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
                    buildTextField("Age", ageController,
                        keyboardType: TextInputType.number),
                    buildTextField("Contact Number", contactController,
                        keyboardType: TextInputType.phone),
                    buildGenderField(),
                    buildTextField("Email", emailController,
                        keyboardType: TextInputType.emailAddress),
                    buildTextField("Address", addressController, maxLines: 2),
                    buildDatePickerField(
                        "Preferred Date", preferredTimeController),
                    buildTextField(
                        "Referred By Doctor", referredByDoctorController),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      ),
                      onPressed: submitForm,
                      child:
                          Text("Submit", style: TextStyle(color: Colors.white)),
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

  Widget buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: color)),
        Row(
          children: [
            buildRadioOption('Male'),
            buildRadioOption('Female'),
            buildRadioOption('Transgender'),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildRadioOption(String value) {
    return Row(
      children: [
        Radio<String>(
          activeColor: color,
          value: value,
          groupValue: gender,
          onChanged: (val) => setState(() => gender = val!),
        ),
        Text(value),
      ],
    );
  }
}
