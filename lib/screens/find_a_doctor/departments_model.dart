// To parse this JSON data, do
//
//     final departments = departmentsFromJson(jsonString);

import 'dart:convert';

Departments departmentsFromJson(String str) =>
    Departments.fromJson(json.decode(str));

String departmentsToJson(Departments data) => json.encode(data.toJson());

class Departments {
  String status;
  List<DepartmentInfo> data;

  Departments({
    required this.status,
    required this.data,
  });

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
        status: json["status"],
        data: List<DepartmentInfo>.from(
            json["data"].map((x) => DepartmentInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DepartmentInfo {
  String departmentName;
  String logoUrl;
  String uploadDate;

  DepartmentInfo({
    required this.departmentName,
    required this.logoUrl,
    required this.uploadDate,
  });

  factory DepartmentInfo.fromJson(Map<String, dynamic> json) => DepartmentInfo(
        departmentName: json["department_name"],
        logoUrl: json["logo_url"],
        uploadDate: json["upload_date"],
      );

  Map<String, dynamic> toJson() => {
        "department_name": departmentName,
        "logo_url": logoUrl,
        "upload_date": uploadDate,
      };
}
