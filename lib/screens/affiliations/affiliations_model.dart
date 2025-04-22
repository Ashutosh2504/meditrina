// To parse this JSON data, do
//
//     final affiliationsModel = affiliationsModelFromJson(jsonString);

import 'dart:convert';

AffiliationsModel affiliationsModelFromJson(String str) =>
    AffiliationsModel.fromJson(json.decode(str));

String affiliationsModelToJson(AffiliationsModel data) =>
    json.encode(data.toJson());

class AffiliationsModel {
  String status;
  List<Affiliation> data;

  AffiliationsModel({
    required this.status,
    required this.data,
  });

  factory AffiliationsModel.fromJson(Map<String, dynamic> json) =>
      AffiliationsModel(
        status: json["status"],
        data: List<Affiliation>.from(
            json["data"].map((x) => Affiliation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Affiliation {
  String id;
  String logoName;
  String logo;
  String date;
  String status;
  String logoType;

  Affiliation({
    required this.id,
    required this.logoName,
    required this.logo,
    required this.date,
    required this.status,
    required this.logoType,
  });

  factory Affiliation.fromJson(Map<String, dynamic> json) => Affiliation(
        id: json["id"],
        logoName: json["logo_name"],
        logo: json["logo"],
        date: json["date"],
        status: json["status"],
        logoType: json["logo_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo_name": logoName,
        "logo": logo,
        "date": date,
        "status": status,
        "logo_type": logoType,
      };
}
