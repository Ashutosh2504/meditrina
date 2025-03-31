// To parse this JSON data, do
//
//     final reportsList = reportsListFromJson(jsonString);

import 'dart:convert';

ReportsList reportsListFromJson(String str) =>
    ReportsList.fromJson(json.decode(str));

String reportsListToJson(ReportsList data) => json.encode(data.toJson());

class ReportsList {
  String status;
  List<Datum> data;

  ReportsList({
    required this.status,
    required this.data,
  });

  factory ReportsList.fromJson(Map<String, dynamic> json) => ReportsList(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String reportId;
  String reportName;
  String reportFile;
  String patientId;
  String patientName;
  String reportDate;
  String updateReportDate;

  Datum({
    required this.reportId,
    required this.reportName,
    required this.reportFile,
    required this.patientId,
    required this.patientName,
    required this.reportDate,
    required this.updateReportDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reportId: json["report_id"],
        reportName: json["report_name"],
        reportFile: json["report_file"],
        patientId: json["patient_id"],
        patientName: json["patient_name"],
        reportDate: json["report_date"],
        updateReportDate: json["update_report_date"],
      );

  Map<String, dynamic> toJson() => {
        "report_id": reportId,
        "report_name": reportName,
        "report_file": reportFile,
        "patient_id": patientId,
        "patient_name": patientName,
        "report_date": reportDate,
        "update_report_date": updateReportDate,
      };
}
