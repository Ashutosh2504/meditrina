import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meditrina_01/screens/patient_portal/patient_info.dart';

class SecureStorageService {
  final _storage = FlutterSecureStorage();

  Future<void> savePhone(String phone) async {
    await _storage.write(key: 'userPhone', value: phone);
  }

  Future<String?> getPhone() async {
    return await _storage.read(key: 'userPhone');
  }

  Future<void> clearPhone() async {
    await _storage.delete(key: 'userPhone');
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> savePatientInfo(PatientInfo patientInfo) async {
    String jsonString = jsonEncode(patientInfo.toJson());
    await _storage.write(key: "patientInfo", value: jsonString);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }
}
