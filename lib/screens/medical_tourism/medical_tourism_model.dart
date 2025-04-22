// To parse this JSON data, do
//
//     final medicalTourismsModel = medicalTourismsModelFromJson(jsonString);

import 'dart:convert';

MedicalTourismsModel medicalTourismsModelFromJson(String str) =>
    MedicalTourismsModel.fromJson(json.decode(str));

String medicalTourismsModelToJson(MedicalTourismsModel data) =>
    json.encode(data.toJson());

class MedicalTourismsModel {
  String status;
  List<MedicalTourism> data;

  MedicalTourismsModel({
    required this.status,
    required this.data,
  });

  factory MedicalTourismsModel.fromJson(Map<String, dynamic> json) =>
      MedicalTourismsModel(
        status: json["status"],
        data: List<MedicalTourism>.from(
            json["data"].map((x) => MedicalTourism.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MedicalTourism {
  String id;
  String category;
  String details;
  String date;

  MedicalTourism({
    required this.id,
    required this.category,
    required this.details,
    required this.date,
  });

  factory MedicalTourism.fromJson(Map<String, dynamic> json) => MedicalTourism(
        id: json["id"],
        category: json["category"],
        details: json["details"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "details": details,
        "date": date,
      };
}
