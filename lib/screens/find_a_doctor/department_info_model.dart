// To parse this JSON data, do
//
//     final departmentInfoModel = departmentInfoModelFromJson(jsonString);

import 'dart:convert';

DepartmentInfoModel departmentInfoModelFromJson(String str) =>
    DepartmentInfoModel.fromJson(json.decode(str));

String departmentInfoModelToJson(DepartmentInfoModel data) =>
    json.encode(data.toJson());

class DepartmentInfoModel {
  bool success;
  List<Datum> data;

  DepartmentInfoModel({
    required this.success,
    required this.data,
  });

  factory DepartmentInfoModel.fromJson(Map<String, dynamic> json) =>
      DepartmentInfoModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String department;
  String content;
  String date;

  Datum({
    required this.id,
    required this.department,
    required this.content,
    required this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        department: json["department"],
        content: json["content"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "department": department,
        "content": content,
        "date": date,
      };
}
