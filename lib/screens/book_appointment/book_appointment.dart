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

  String name = '';
  String contactNumber = '';
  String email = '';
  String homeAddress = '';
  DateTime? appointmentDate;
  TimeOfDay? appointmentTime;

  Dio dio = Dio();
  Future bookAppointment(BookAppointmentModel appointment) async {
    try {
      final response = await dio.post(
        'https://meditrinainstitute.com/report_software/api/book_appointment.php', // Adjust the endpoint if necessary
        data: appointment.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Appointment booked successfully!");
        print("Response: ${response.data}");
        await Alerts.showAlert(
            true, context, "Appointment booked successfully!");
      } else {
        print(
            "Failed to book appointment. Status Code: ${response.statusCode}");
        return response.data;
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void submitForm() async {
    DateTime currentDates = DateTime.now();
    String curDate =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    if (_formKey.currentState!.validate() &&
        appointmentDate != null &&
        appointmentTime != null) {
      _formKey.currentState!.save();

      // API Call to submit data (Placeholder)
      print('Name: $name');
      print('Contact Number: $contactNumber');
      print('Email: $email');
      print('Home Address: $homeAddress');
      print(
          'Appointment Date: ${DateFormat('yyyy-MM-dd').format(appointmentDate!)}');
      print('Appointment Time: ${appointmentTime!.format(context)}');
      print('Doctor: ${widget.selectedDoctor}');
      print('Department: ${widget.selectedDepartment}');
      final appointment = BookAppointmentModel(
          name: name,
          mobile: contactNumber,
          email: email,
          address: homeAddress,
          appointmentDate: appointmentDate.toString(),
          department: widget.selectedDepartment,
          doctor: widget.selectedDoctor,
          currentDates: curDate,
          fees: "fees",
          paymentStatus: "paymentStatus");
      await bookAppointment(appointment);
      Navigator.pop(context);
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
      setState(() {
        appointmentDate = pickedDate;
      });
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        appointmentTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.length != 10
                    ? 'Enter a valid 10-digit number'
                    : null,
                onSaved: (value) => contactNumber = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Enter a valid email',
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Home Address'),
                onSaved: (value) => homeAddress = value!,
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                    'Select Appointment Date: ${appointmentDate != null ? DateFormat('dd-MMM-yyyy').format(appointmentDate!) : 'Not Selected'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: pickDate,
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                    'Select Appointment Time: ${appointmentTime != null ? appointmentTime!.format(context) : 'Not Selected'}'),
                trailing: Icon(Icons.access_time),
                onTap: pickTime,
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Dr.",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Submit Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
