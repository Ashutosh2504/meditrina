// To parse this JSON data, do
//
//     final departmentDoctorsModel = departmentDoctorsModelFromJson(jsonString);

import 'dart:convert';

DepartmentDoctorsModel departmentDoctorsModelFromJson(String str) =>
    DepartmentDoctorsModel.fromJson(json.decode(str));

String departmentDoctorsModelToJson(DepartmentDoctorsModel data) =>
    json.encode(data.toJson());

class DepartmentDoctorsModel {
  String status;
  List<DepartmentDoctors> data;

  DepartmentDoctorsModel({
    required this.status,
    required this.data,
  });

  factory DepartmentDoctorsModel.fromJson(Map<String, dynamic> json) =>
      DepartmentDoctorsModel(
        status: json["status"],
        data: List<DepartmentDoctors>.from(
            json["data"].map((x) => DepartmentDoctors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DepartmentDoctors {
  String docId;
  String doctorName;
  String mobile;
  String email;
  String education;
  String speciality;
  String departmentName;
  String docImage;
  String date;

  DepartmentDoctors({
    required this.docId,
    required this.doctorName,
    required this.mobile,
    required this.email,
    required this.education,
    required this.speciality,
    required this.departmentName,
    required this.docImage,
    required this.date,
  });

  factory DepartmentDoctors.fromJson(Map<String, dynamic> json) =>
      DepartmentDoctors(
        docId: json["doc_id"],
        doctorName: json["doctor_name"],
        mobile: json["mobile"],
        email: json["email"],
        education: json["education"],
        speciality: json["speciality"],
        departmentName: json["department_name"],
        docImage: json["doc_image"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "doc_id": docId,
        "doctor_name": doctorName,
        "mobile": mobile,
        "email": email,
        "education": education,
        "speciality": speciality,
        "department_name": departmentName,
        "doc_image": docImage,
        "date": date,
      };
}
