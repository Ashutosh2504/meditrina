// To parse this JSON data, do
//
//     final aboutUsModel = aboutUsModelFromJson(jsonString);

import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) =>
    AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  String status;
  List<AboutUs> data;

  AboutUsModel({
    required this.status,
    required this.data,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        status: json["status"],
        data: List<AboutUs>.from(json["data"].map((x) => AboutUs.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AboutUs {
  String id;
  String content;
  String date;

  AboutUs({
    required this.id,
    required this.content,
    required this.date,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) => AboutUs(
        id: json["id"],
        content: json["content"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "date": date,
      };
}
