// To parse this JSON data, do
//
//     final onlinePathalogyModel = onlinePathalogyModelFromJson(jsonString);

import 'dart:convert';

OnlinePathalogyModel onlinePathalogyModelFromJson(String str) =>
    OnlinePathalogyModel.fromJson(json.decode(str));

String onlinePathalogyModelToJson(OnlinePathalogyModel data) =>
    json.encode(data.toJson());

class OnlinePathalogyModel {
  bool status;
  List<OnlinePathalogy> data;

  OnlinePathalogyModel({
    required this.status,
    required this.data,
  });

  factory OnlinePathalogyModel.fromJson(Map<String, dynamic> json) =>
      OnlinePathalogyModel(
        status: json["status"],
        data: List<OnlinePathalogy>.from(
            json["data"].map((x) => OnlinePathalogy.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class OnlinePathalogy {
  String testId;
  String category;
  String testName;
  String fees;
  String date;

  OnlinePathalogy({
    required this.testId,
    required this.category,
    required this.testName,
    required this.fees,
    required this.date,
  });

  factory OnlinePathalogy.fromJson(Map<String, dynamic> json) =>
      OnlinePathalogy(
        testId: json["test_id"],
        category: json["category"],
        testName: json["test_name"],
        fees: json["fees"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "test_id": testId,
        "category": category,
        "test_name": testName,
        "fees": fees,
        "date": date,
      };
}
