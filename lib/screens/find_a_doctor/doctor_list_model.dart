// To parse this JSON data, do
//
//     final doctorsListModel = doctorsListModelFromJson(jsonString);

import 'dart:convert';

DoctorsListModel doctorsListModelFromJson(String str) =>
    DoctorsListModel.fromJson(json.decode(str));

String doctorsListModelToJson(DoctorsListModel data) =>
    json.encode(data.toJson());

class DoctorsListModel {
  String status;
  List<DocModel> data;

  DoctorsListModel({
    required this.status,
    required this.data,
  });

  factory DoctorsListModel.fromJson(Map<String, dynamic> json) =>
      DoctorsListModel(
        status: json["status"],
        data:
            List<DocModel>.from(json["data"].map((x) => DocModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DocModel {
  String docId;
  String doctorName;
  String mobile;
  String email;
  String education;
  String speciality;
  String departmentName;
  String docImage;
  String date;

  DocModel({
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

  factory DocModel.fromJson(Map<String, dynamic> json) => DocModel(
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
