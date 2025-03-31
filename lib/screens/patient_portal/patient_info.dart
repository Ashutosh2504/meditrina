class PatientInfo {
  int id;
  int masterId;
  String fullName;
  String mobileNumber;
  String age;
  String gender;
  String consultingDoctor;
  String testPrescribed;
  int otp;
  String date;

  PatientInfo({
    required this.id,
    required this.masterId,
    required this.fullName,
    required this.mobileNumber,
    required this.age,
    required this.gender,
    required this.consultingDoctor,
    required this.testPrescribed,
    required this.otp,
    required this.date,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
        id: json["id"],
        masterId: json["master_id"],
        fullName: json["full_name"],
        mobileNumber: json["mobile_number"],
        age: json["age"],
        gender: json["gender"],
        consultingDoctor: json["consulting_doctor"],
        testPrescribed: json["test_prescribed"],
        otp: json["otp"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "master_id": masterId,
        "full_name": fullName,
        "mobile_number": mobileNumber,
        "age": age,
        "gender": gender,
        "consulting_doctor": consultingDoctor,
        "test_prescribed": testPrescribed,
        "otp": otp,
        "date": date,
      };
}
