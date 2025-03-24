// To parse this JSON data, do
//
//     final BookAppointmentModel = BookAppointmentModelFromJson(jsonString);

import 'dart:convert';

BookAppointmentModel BookAppointmentModelFromJson(String str) =>
    BookAppointmentModel.fromJson(json.decode(str));

String BookAppointmentModelToJson(BookAppointmentModel data) =>
    json.encode(data.toJson());

class BookAppointmentModel {
  String name;
  String mobile;
  String email;
  String address;
  String appointmentDate;
  String department;
  String doctor;
  String currentDates;
  String fees;
  String paymentStatus;

  BookAppointmentModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.appointmentDate,
    required this.department,
    required this.doctor,
    required this.currentDates,
    required this.fees,
    required this.paymentStatus,
  });

  factory BookAppointmentModel.fromJson(Map<String, dynamic> json) =>
      BookAppointmentModel(
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
        appointmentDate: json["appointment_date"],
        department: json["department"],
        doctor: json["doctor"],
        currentDates: json["current_dates"],
        fees: json["fees"],
        paymentStatus: json["payment_status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "email": email,
        "address": address,
        "appointment_date": appointmentDate,
        "department": department,
        "doctor": doctor,
        "current_dates": currentDates,
        "fees": fees,
        "payment_status": paymentStatus,
      };

      
}


