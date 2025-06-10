import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrina_01/screens/book_appointment/model_book_appointment.dart';
import 'package:meditrina_01/screens/find_a_doctor/departments_model.dart';
import 'package:meditrina_01/screens/find_a_doctor/dept_doc_model.dart';
import 'package:meditrina_01/screens/find_a_doctor/doctor_list_model.dart';
import 'package:meditrina_01/util/alerts.dart';
import 'package:meditrina_01/util/payment_gateway.dart';
import 'package:meditrina_01/util/payment_success.dart';
import 'package:meditrina_01/util/razorpay_gateway.dart';

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
  bool isDepartmentLoading = false;
  bool isDoctorLoading = false;

  String name = '';
  String contactNumber = '';
  String email = '';
  String homeAddress = '';
  DateTime? appointmentDate;
  TimeOfDay? appointmentTime;
  String? selectedDoctorName;
  TextEditingController manualDoctorController = TextEditingController();

  Dio dio = Dio();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  List<String> departmentList = [];
  List<DocModel> doctorList = [];
  late String selectedDepartment;

  @override
  void initState() {
    super.initState();
    selectedDepartment = widget.selectedDepartment;

    if (widget.doctorList.isEmpty || selectedDepartment.isEmpty) {
      fetchDepartments();
    } else {
      doctorList = widget.doctorList;
      if (doctorList.length == 1) {
        selectedDoctorName = doctorList.first.doctorName;
      }
    }
  }

  Future<void> fetchDepartments() async {
    setState(() {
      isDepartmentLoading = true;
    });

    try {
      final response = await dio.get(
        'https://meditrinainstitute.com/report_software/api/get_department.php',
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        // Decode JSON using your Departments model
        final departments = Departments.fromJson(response.data);

        departmentList =
            departments.data.map((dept) => dept.departmentName).toList();

        if (departmentList.isNotEmpty) {
          selectedDepartment = departmentList.first;
          await fetchDoctors(selectedDepartment);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load departments.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching departments: $e")),
      );
      print("Departments fail: $e");
    } finally {
      setState(() {
        isDepartmentLoading = false;
      });
    }
  }

  Future<void> fetchDoctors(String department) async {
    setState(() {
      isDoctorLoading = true;
    });
    try {
      final response = await dio.get(
        'https://meditrinainstitute.com/report_software/api/get_doctor.php',
        queryParameters: {
          'department': department,
        },
      );
      if (response.statusCode == 200) {
        final doctorsModel = DepartmentDoctorsModel.fromJson(response.data);

        // Convert DepartmentDoctors to DocModel
        doctorList = doctorsModel.data
            .map((doctor) => DocModel(
                  docId: doctor.docId,
                  doctorName: doctor.doctorName,
                  mobile: doctor.mobile,
                  email: doctor.email,
                  education: doctor.education,
                  speciality: doctor.speciality,
                  departmentName: doctor.departmentName,
                  docImage: doctor.docImage,
                  date: doctor.date,
                  profile: doctor.profile,
                ))
            .toList();

        // Auto-select the doctor if there is only one
        if (doctorList.isNotEmpty && doctorList.length == 1) {
          selectedDoctorName = doctorList.first.doctorName;
        }
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Error fetching doctors: $e")));
      print("Doctors fetch failed");
      print(e);
    } finally {
      setState(() {
        isDoctorLoading = false;
      });
    }
  }

  void submitForm() async {
    final doctorName = doctorList.isEmpty
        ? manualDoctorController.text.trim()
        : selectedDoctorName;

    if (_formKey.currentState!.validate() &&
        appointmentDate != null &&
        appointmentTime != null &&
        doctorName != null &&
        doctorName.isNotEmpty) {
      _formKey.currentState!.save();

      final appointment = BookAppointmentModel(
        name: name,
        mobile: contactNumber,
        email: email,
        address: homeAddress,
        appointmentDate: appointmentDate.toString(),
        department: selectedDepartment.trim(),
        doctor: doctorName,
        currentDates: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        fees: "700", // Replace this with dynamic fee fetching if needed
        paymentStatus: "Pending",
        time: appointmentTime!.format(context).toString(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RazorpayPaymentScreen(
            amount: 700, // ₹500
            userName: appointment.name,
            contact: appointment.mobile,
            email: appointment.email,
            onPaymentSuccess: (response) async {
              await bookAppointment(appointment);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
              // );
              Navigator.pop(context, true);
            },
            onPaymentError: (response) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Payment failed: ${response.message}")),
              );
              Navigator.pop(context, false);
            },
          ),
        ),
      );
      // await bookAppointment(appointment);
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
        // await Alerts.showAlert(true, context, "Please proceed to payment");

        // Navigator.pop(context);
        // making new changes to test razorpay payments

        _formKey.currentState?.reset();
        manualDoctorController.clear();
        setState(() {
          appointmentDate = null;
          appointmentTime = null;
          selectedDoctorName =
              doctorList.length == 1 ? doctorList.first.doctorName : null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      Navigator.pop(context);
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
                child:
                    Image.asset("assets/images/kk.jpg", width: 80, height: 80),
              ),
              const SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: color),
                    children: const [
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
              const SizedBox(height: 20),
              TextFormField(
                decoration: _buildInputDecoration("Name*", Icons.person),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                onSaved: (value) => name = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration:
                    _buildInputDecoration("Contact Number*", Icons.call),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.length != 10 ? 'Enter valid number' : null,
                onSaved: (value) => contactNumber = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: _buildInputDecoration("Email*", Icons.mail),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Enter a valid email',
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: _buildInputDecoration("Home Address*", Icons.home),
                onSaved: (value) => homeAddress = value!,
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              if (departmentList.isEmpty)
                CircularProgressIndicator()
              else
                Container(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    value: selectedDepartment.isEmpty
                        ? departmentList.first
                        : selectedDepartment,
                    items: departmentList.map((department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Text(
                          department,
                          softWrap: true,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (newDepartment) async {
                      if (newDepartment != null) {
                        setState(() {
                          selectedDepartment = newDepartment;
                          doctorList.clear(); // Clear previous doctors
                          selectedDoctorName = null;
                          manualDoctorController
                              .clear(); // Clear manual input too
                        });
                        await fetchDoctors(newDepartment);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Department',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              if (isDoctorLoading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    const SizedBox(height: 10),
                    if (isDoctorLoading)
                      Center(child: CircularProgressIndicator())
                    else if (doctorList.isEmpty)
                      TextFormField(
                        controller: manualDoctorController,
                        decoration:
                            _buildInputDecoration("Doctor Name*", Icons.person),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter Doctor\'s Name'
                            : null,
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Doctor*",
                              style: TextStyle(color: color)),
                          const SizedBox(height: 4),
                          ...doctorList.map((doc) {
                            return RadioListTile<String>(
                              value: doc.doctorName,
                              groupValue: selectedDoctorName,
                              onChanged: (value) {
                                setState(() {
                                  selectedDoctorName = value;
                                });
                              },
                              title: Text(
                                doc.doctorName,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color, // your preferred blue color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: isLoading ? null : submitForm,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Book Appointment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
      prefixIcon: Icon(icon, color: color),
      border: OutlineInputBorder(),
    );
  }
}
