import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrina_01/screens/book_appointment/model_book_appointment.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';
import 'package:meditrina_01/util/alerts.dart';
import 'package:meditrina_01/util/payment_gateway.dart';

class MyBookAppointment extends StatefulWidget {
  final List<DocModel> doctorList;
  final String selectedDepartment;

  const MyBookAppointment({
    Key? key,
    required this.doctorList,
    required this.selectedDepartment,
  }) : super(key: key);

  @override
  State<MyBookAppointment> createState() => _MyBookAppointmentState();
}

class _MyBookAppointmentState extends State<MyBookAppointment> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String name = '';
  String contactNumber = '';
  String email = '';
  String homeAddress = '';
  DateTime? appointmentDate;
  TimeOfDay? appointmentTime;
  String? selectedDoctorName;

  Dio dio = Dio();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  void initState() {
    super.initState();
    if (widget.doctorList.length == 1) {
      selectedDoctorName = widget.doctorList.first.doctorName;
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() &&
        appointmentDate != null &&
        appointmentTime != null &&
        selectedDoctorName != null) {
      _formKey.currentState!.save();
      final appointment = BookAppointmentModel(
        name: name,
        mobile: contactNumber,
        email: email,
        address: homeAddress,
        appointmentDate: appointmentDate.toString(),
        department: widget.selectedDepartment.trim(),
        doctor: selectedDoctorName!.trim(),
        currentDates: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        fees: "fees",
        paymentStatus: "paymentStatus",
      );
      await bookAppointment(appointment);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(amount: 500),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields.")),
      );
    }
  }

  Future<void> bookAppointment(BookAppointmentModel appointment) async {
    setState(() => isLoading = true);
    try {
      final response = await dio.post(
        'https://meditrinainstitute.com/report_software/api/book_appointment.php',
        data: appointment.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await Alerts.showAlert(
            true, context, "Appointment booked successfully!");
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() => appointmentDate = pickedDate);
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => appointmentTime = pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text('Book Appointment', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/kk.jpg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: color),
                      children: [
                        TextSpan(text: "Book an "),
                        TextSpan(
                            text: "Appointment",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " and "),
                        TextSpan(
                            text: "Experience Quality",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " with us."),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: _buildInputDecoration("Name*", Icons.person),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration:
                    _buildInputDecoration("Contact Number*", Icons.call),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.length != 10 ? 'Enter valid number' : null,
                onSaved: (value) => contactNumber = value!,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: _buildInputDecoration("Email*", Icons.mail),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Enter a valid email',
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: _buildInputDecoration("Home Address*", Icons.home),
                onSaved: (value) => homeAddress = value!,
              ),
              SizedBox(height: 15),
              ListTile(
                title: Text(
                  appointmentDate != null
                      ? DateFormat('dd-MMM-yyyy').format(appointmentDate!)
                      : 'Select Date*',
                  style: TextStyle(color: color),
                ),
                trailing: Icon(Icons.calendar_today, color: color),
                onTap: pickDate,
              ),
              ListTile(
                title: Text(
                  appointmentTime != null
                      ? appointmentTime!.format(context)
                      : 'Select Time*',
                  style: TextStyle(color: color),
                ),
                trailing: Icon(Icons.access_time, color: color),
                onTap: pickTime,
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 10,
              ),
              if (widget.doctorList.isEmpty)
                TextFormField(
                  decoration:
                      _buildInputDecoration("Doctor Name*", Icons.person_pin),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter doctor name' : null,
                  onSaved: (value) => selectedDoctorName = value!,
                )
              else ...[
                Text("Select Doctor*",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                ...widget.doctorList.map((doc) => RadioListTile<String>(
                      title: Text(doc.doctorName),
                      value: doc.doctorName,
                      groupValue: selectedDoctorName,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() => selectedDoctorName = value);
                      },
                    )),
              ],
              SizedBox(height: 15),
              TextFormField(
                initialValue: widget.selectedDepartment,
                readOnly: true,
                decoration: _buildInputDecoration(
                    "Department*", Icons.medical_information),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : submitForm,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Submit Appointment',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: color),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: Icon(icon, color: color),
    );
  }
}
