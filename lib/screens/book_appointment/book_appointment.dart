import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrina_01/screens/book_appointment/model_book_appointment.dart';
import 'package:meditrina_01/util/alerts.dart';

class MyBookAppointment extends StatefulWidget {
  final String selectedDoctor;
  final String selectedDepartment;

  const MyBookAppointment({
    Key? key,
    required this.selectedDoctor,
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
  TextEditingController doctorController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  Dio dio = Dio();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  void initState() {
    super.initState();
    doctorController.text = widget.selectedDoctor;
    departmentController.text = widget.selectedDepartment;
  }

  @override
  void dispose() {
    doctorController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() &&
        appointmentDate != null &&
        appointmentTime != null) {
      _formKey.currentState!.save();
      final appointment = BookAppointmentModel(
        name: name,
        mobile: contactNumber,
        email: email,
        address: homeAddress,
        appointmentDate: appointmentDate.toString(),
        department: departmentController.text.trim(),
        doctor: doctorController.text.trim(),
        currentDates: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        fees: "fees",
        paymentStatus: "paymentStatus",
      );
      await bookAppointment(appointment);
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
          SnackBar(
              content:
                  Text("Failed to book appointment: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name*",
                  labelStyle:
                      TextStyle(color: color), // Set the label color to blue
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: color), // Set the border color to blue
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add rounded corners
                  ),
                  prefixIcon: Icon(
                    Icons.person, // Set the icon of your choice
                    color: color, // Set the icon color
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Contact Number*",
                  labelStyle:
                      TextStyle(color: color), // Set the label color to blue
                  // border: OutlineInputBorder(), // Remove the default border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: color), // Set the border color to blue
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add rounded corners
                  ),
                  prefixIcon: Icon(
                    Icons.call, // Set the icon of your choice
                    color: color, // Set the icon color
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.length != 10 ? 'Enter valid number' : null,
                onSaved: (value) => contactNumber = value!,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email*",
                  labelStyle:
                      TextStyle(color: color), // Set the label color to blue
                  // Remove the default border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: color), // Set the border color to blue
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add rounded corners
                  ),
                  prefixIcon: Icon(
                    Icons.mail, // Set the icon of your choice
                    color: color, // Set the icon color
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Enter a valid email',
                onSaved: (value) => email = value!,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Home Address*",
                  labelStyle:
                      TextStyle(color: color), // Set the label color to blue
                  // border: OutlineInputBorder(), // Remove the default border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: color), // Set the border color to blue
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add rounded corners
                  ),
                  prefixIcon: Icon(
                    Icons.home, // Set the icon of your choice
                    color: color, // Set the icon color
                  ),
                ),
                onSaved: (value) => homeAddress = value!,
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  appointmentDate != null
                      ? DateFormat('dd-MMM-yyyy').format(appointmentDate!)
                      : 'Select Date*',
                  style: TextStyle(color: color),
                ),
                trailing: Icon(
                  Icons.calendar_today,
                  color: color,
                ),
                onTap: pickDate,
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  appointmentTime != null
                      ? appointmentTime!.format(context)
                      : 'Select Time*',
                  style: TextStyle(color: color),
                ),
                trailing: Icon(
                  Icons.access_time,
                  color: color,
                ),
                onTap: pickTime,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: doctorController,
                decoration: InputDecoration(
                  labelText: "Doctor*",
                  labelStyle:
                      TextStyle(color: color), // Set the label color to blue
                  // border: OutlineInputBorder(), // Remove the default border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: color), // Set the border color to blue
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add rounded corners
                  ),
                  prefixIcon: Icon(
                    Icons.person_3_rounded, // Set the icon of your choice
                    color: color, // Set the icon color
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter doctor name' : null,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: departmentController,
                decoration: InputDecoration(
                  labelText: "Department*",
                  labelStyle:
                      TextStyle(color: color), // Set the label color to blue
                  // border: OutlineInputBorder(), // Remove the default border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: color), // Set the border color to blue
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add rounded corners
                  ),
                  prefixIcon: Icon(
                    Icons.medical_information, // Set the icon of your choice
                    color: color, // Set the icon color
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter department' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : submitForm,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Submit Appointment',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
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
}
