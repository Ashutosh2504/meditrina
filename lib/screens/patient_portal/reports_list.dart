// To parse this JSON data, do
//
//     final reportsList = reportsListFromJson(jsonString);

import 'dart:convert';

ReportsList reportsListFromJson(String str) =>
    ReportsList.fromJson(json.decode(str));

String reportsListToJson(ReportsList data) => json.encode(data.toJson());

class ReportsList {
  String status;
  List<ReportsModel> data;

  ReportsList({
    required this.status,
    required this.data,
  });

  factory ReportsList.fromJson(Map<String, dynamic> json) => ReportsList(
        status: json["status"],
        data: List<ReportsModel>.from(
            json["data"].map((x) => ReportsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ReportsModel {
  String reportId;
  String reportName;
  String reportFile;
  String patientId;
  String patientName;
  String reportDate;
  String updateReportDate;
  String doctorName;

  ReportsModel({
    required this.reportId,
    required this.reportName,
    required this.reportFile,
    required this.patientId,
    required this.patientName,
    required this.reportDate,
    required this.updateReportDate,
    required this.doctorName,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
        reportId: json["report_id"],
        reportName: json["report_name"],
        reportFile: json["report_file"],
        patientId: json["patient_id"],
        patientName: json["patient_name"],
        reportDate: json["report_date"],
        updateReportDate: json["update_report_date"],
        doctorName: json["doctor_name"],
      );

  Map<String, dynamic> toJson() => {
        "report_id": reportId,
        "report_name": reportName,
        "report_file": reportFile,
        "patient_id": patientId,
        "patient_name": patientName,
        "report_date": reportDate,
        "update_report_date": updateReportDate,
        "doctor_name": doctorName,
      };
}
