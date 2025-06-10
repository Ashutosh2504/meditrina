import 'dart:convert';

PathalogyPaymentModel pathalogyPaymentModelFromJson(String str) =>
    PathalogyPaymentModel.fromJson(json.decode(str));

String pathalogyPaymentModelToJson(PathalogyPaymentModel data) =>
    json.encode(data.toJson());

class PathalogyPaymentModel {
  String tnxId;
  String patientName;
  String email;
  String mobile;
  List<String> testsName;
  String amount;
  String status;
  String address;
  String time;
  DateTime date;

  PathalogyPaymentModel({
    required this.tnxId,
    required this.patientName,
    required this.email,
    required this.mobile,
    required this.testsName,
    required this.amount,
    required this.status,
    required this.date,
    required this.time,
    required this.address,
  });

  factory PathalogyPaymentModel.fromJson(Map<String, dynamic> json) =>
      PathalogyPaymentModel(
        tnxId: json["tnx_id"],
        patientName: json["patient_name"],
        email: json["email"],
        mobile: json["mobile"],
        testsName: List<String>.from(json["tests_name"].map((x) => x)),
        amount: json["amount"],
        status: json["status"],
        address: json["address"] ?? "",
        time: json["time"] ?? "",
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "tnx_id": tnxId,
        "patient_name": patientName,
        "email": email,
        "mobile": mobile,
        "tests_name": List<dynamic>.from(testsName.map((x) => x)),
        "amount": amount,
        "status": status,
        "address": address,
        "time": time,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };

  PathalogyPaymentModel copyWith({
    String? tnxId,
    String? patientName,
    String? email,
    String? mobile,
    List<String>? testsName,
    String? amount,
    String? status,
    String? address,
    String? time,
    DateTime? date,
  }) {
    return PathalogyPaymentModel(
      tnxId: tnxId ?? this.tnxId,
      patientName: patientName ?? this.patientName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      testsName: testsName ?? this.testsName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      address: address ?? this.address,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }
}
