// To parse this JSON data, do
//
//     final ourFacilitiesModel = ourFacilitiesModelFromJson(jsonString);

import 'dart:convert';

OurFacilitiesModel ourFacilitiesModelFromJson(String str) =>
    OurFacilitiesModel.fromJson(json.decode(str));

String ourFacilitiesModelToJson(OurFacilitiesModel data) =>
    json.encode(data.toJson());

class OurFacilitiesModel {
  String status;
  List<FacilityModel> data;

  OurFacilitiesModel({
    required this.status,
    required this.data,
  });

  factory OurFacilitiesModel.fromJson(Map<String, dynamic> json) =>
      OurFacilitiesModel(
        status: json["status"],
        data: List<FacilityModel>.from(
            json["data"].map((x) => FacilityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FacilityModel {
  String id;
  String logoName;
  String logo;
  String date;
  String status;
  String logoType;

  FacilityModel({
    required this.id,
    required this.logoName,
    required this.logo,
    required this.date,
    required this.status,
    required this.logoType,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) => FacilityModel(
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
