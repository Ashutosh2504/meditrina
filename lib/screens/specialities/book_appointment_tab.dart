import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';

class BookAppointmentTab extends StatefulWidget {
  final String department;
  final List<DocModel> doctors;

  const BookAppointmentTab({
    Key? key,
    required this.department,
    required this.doctors,
  }) : super(key: key);

  @override
  State<BookAppointmentTab> createState() => _BookAppointmentTabState();
}

class _BookAppointmentTabState extends State<BookAppointmentTab> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();
  final manualDoctorController = TextEditingController();

  String selectedGender = 'Male';
  String? selectedDate;
  String? selectedTime;

  List<DocModel> doctors = [];
  DocModel? selectedDoctor;
  bool isLoading = true;

  Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  void initState() {
    super.initState();
    fetchDepartmentDoctors(widget.department).then((fetchedDoctors) {
      setState(() {
        doctors = fetchedDoctors;
        if (doctors.length == 1) {
          selectedDoctor = doctors.first;
        }
        isLoading = false;
      });
    });
  }

  Future<List<DocModel>> fetchDepartmentDoctors(String department) async {
    try {
      var response = await Dio().get(
        "https://meditrinainstitute.com/report_software/api/get_doctor.php",
        queryParameters: {"department": department},
      );

      if (response.statusCode == 200) {
        DoctorsListModel doctorsModel =
            DoctorsListModel.fromJson(response.data);
        return doctorsModel.data;
      } else {
        throw Exception("Failed to load doctors");
      }
    } catch (e) {
      setState(() => isLoading = false);
      throw Exception("Error fetching doctors: $e");
    }
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Future<void> pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime.format(context);
      });
    }
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate() &&
        (selectedDoctor != null || manualDoctorController.text.isNotEmpty)) {
      final data = {
        "department": widget.department,
        "doctor": selectedDoctor?.doctorName ?? manualDoctorController.text,
        "name": nameController.text,
        "age": ageController.text,
        "gender": selectedGender,
        "mobile": mobileController.text,
        "date": selectedDate ?? "Not selected",
        "time": selectedTime ?? "Not selected",
      };

      print("Booking Data: $data");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment booked successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: widget.department,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Department',
                labelStyle: TextStyle(color: color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                ),
              ),
            ),
            const SizedBox(height: 16),
            doctors.isEmpty
                ? TextFormField(
                    controller: manualDoctorController,
                    decoration: InputDecoration(
                      labelText: 'Enter Doctor Name',
                      labelStyle: TextStyle(color: color),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  )
                : DropdownButtonFormField<DocModel>(
                    value: selectedDoctor,
                    items: doctors.map((doctor) {
                      return DropdownMenuItem<DocModel>(
                        value: doctor,
                        child: Text(doctor.doctorName),
                      );
                    }).toList(),
                    onChanged: (DocModel? newValue) {
                      setState(() => selectedDoctor = newValue);
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Doctor',
                      labelStyle: TextStyle(color: color),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: color),
                prefixIcon: Icon(Icons.person, color: color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(color: color),
                prefixIcon: Icon(Icons.surfing, color: color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile',
                labelStyle: TextStyle(color: color),
                prefixIcon: Icon(Icons.phone, color: color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.length != 10
                  ? 'Enter valid number'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text("Gender:", style: TextStyle(color: color)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedGender,
                  items: ['Male', 'Female', 'Other'].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Date Label
            Text('Appointment Date', style: TextStyle(color: color)),
            ListTile(
              title: Text(
                selectedDate ?? 'Select Date',
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(Icons.calendar_today, color: color),
              onTap: pickDate,
            ),

            /// Time Label
            Text('Appointment Time', style: TextStyle(color: color)),
            ListTile(
              title: Text(
                selectedTime ?? 'Select Time',
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(Icons.access_time, color: color),
              onTap: pickTime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Book Appointment',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
