// To parse this JSON data, do
//
//     final packagesModel = packagesModelFromJson(jsonString);

import 'dart:convert';

PackagesModel packagesModelFromJson(String str) =>
    PackagesModel.fromJson(json.decode(str));

String packagesModelToJson(PackagesModel data) => json.encode(data.toJson());

class PackagesModel {
  String status;
  List<Package> data;

  PackagesModel({
    required this.status,
    required this.data,
  });

  factory PackagesModel.fromJson(Map<String, dynamic> json) => PackagesModel(
        status: json["status"],
        data: List<Package>.from(json["data"].map((x) => Package.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Package {
  String id;
  String packageName;
  String logo;
  String packageImage;
  String amount;
  String date;
  String status;

  Package({
    required this.id,
    required this.packageName,
    required this.logo,
    required this.packageImage,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        packageName: json["package_name"],
        logo: json["logo"],
        packageImage: json["package_image"],
        amount: json["amount"],
        date: json["date"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "logo": logo,
        "package_image": packageImage,
        "amount": amount,
        "date": date,
        "status": status,
      };
}
