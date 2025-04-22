import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class IPDFeedbackForm extends StatefulWidget {
  const IPDFeedbackForm({Key? key}) : super(key: key);

  @override
  State<IPDFeedbackForm> createState() => _IPDFeedbackFormState();
}

class _IPDFeedbackFormState extends State<IPDFeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  // Form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController visitDateController = TextEditingController();

  // Feedback fields (Radio buttons)
  String q1ReceptionAttend = '';
  String q2Directions = '';
  String q3ConsultantSatisfaction = '';
  String q4RadiologyBehavior = '';
  String q5ProcedureExplanation = '';
  String q6NursingBehavior = '';
  String q7DietCounseling = '';

  bool isLoading = false;

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

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365)),
          );
          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            controller.text = formattedDate;
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            validator: (value) =>
                value == null || value.isEmpty ? 'Select date' : null,
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
      setState(() => isLoading = true);

      final data = {
        "name": nameController.text.trim(),
        "address": addressController.text.trim(),
        "mobile": mobileController.text.trim(),
        "email": emailController.text.trim(),
        "visit_date": visitDateController.text.trim(),
        "q1_reception_attend": q1ReceptionAttend,
        "q2_directions": q2Directions,
        "q3_consultant_satisfaction": q3ConsultantSatisfaction,
        "q4_radiology_behavior": q4RadiologyBehavior,
        "q5_procedure_explanation": q5ProcedureExplanation,
        "q6_nursing_behavior": q6NursingBehavior,
        "q7_diet_counseling": q7DietCounseling
      };

      try {
        var response = await Dio().post(
          'https://meditrinainstitute.com/report_software/api/post_ipd_feedback.php',
          data: data,
        );

        if (response.statusCode == 200) {
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Feedback submitted successfully')),
            );

            // Clear all text controllers
            nameController.clear();
            addressController.clear();
            mobileController.clear();
            emailController.clear();
            visitDateController.clear();

            // Reset all radio selections
            setState(() {
              q1ReceptionAttend = '';
              q2Directions = '';
              q3ConsultantSatisfaction = '';
              q4RadiologyBehavior = '';
              q5ProcedureExplanation = '';
              q6NursingBehavior = '';
              q7DietCounseling = '';
            });
          }
        } else {
          throw Exception('Failed to submit');
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: \$e')));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IPD Feedback Form"), backgroundColor: color),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                    color: color, fontSize: 18, fontWeight: FontWeight.normal),
              ),
              buildRadioButtonField(
                  "",
                  "1. Did the reception personnel attend you promptly?",
                  q1ReceptionAttend,
                  (val) => setState(() => q1ReceptionAttend = val)),
              buildRadioButtonField(
                  "Department",
                  "2. Were you directed to various departments correctly?",
                  q2Directions,
                  (val) => setState(() => q2Directions = val)),
              buildRadioButtonField(
                  "Consultant",
                  "3. How satisfied were you after meeting the consultant?",
                  q3ConsultantSatisfaction,
                  (val) => setState(() => q3ConsultantSatisfaction = val)),
              buildRadioButtonField(
                  "Radiology ",
                  "4. Was the technician/radiographer courteous to you while perfoming the procedure?",
                  q4RadiologyBehavior,
                  (val) => setState(() => q4RadiologyBehavior = val)),
              buildRadioButtonField(
                  "",
                  "5. Rate how was the procedure explained to you by the radiographer/technician. ",
                  q5ProcedureExplanation,
                  (val) => setState(() => q5ProcedureExplanation = val)),
              buildRadioButtonField(
                  "Nursing ",
                  "6. Was the X-Ray, Echo, ECG, TMT technician/nursing staff in treatment room courteous to you",
                  q6NursingBehavior,
                  (val) => setState(() => q6NursingBehavior = val)),
              buildRadioButtonField(
                  "Diet",
                  "7. How effective was the diet counselling?",
                  q7DietCounseling,
                  (val) => setState(() => q7DietCounseling = val)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Submit", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
