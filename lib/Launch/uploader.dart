import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:rankless/User/Employee.dart';

class Uploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadImage(String filePath, Employee employee) async {
    File file = File(filePath);
    try {
      await _storage.ref().child(employee.uid).putFile(file);
    } on FirebaseException catch (e) {
      return 'something went wrong ' + e.message;
    }
    employee.image = file;
  }

  Future getImage(Employee employee) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    File file = new File('${appDocDir.path}/download-profile-pic');

    try {
      await _storage.ref().child(employee.uid).writeToFile(file);
    } on FirebaseException catch (e) {
      return 'somthing went wrong ' + e.message;
    }
    employee.image = file;
  }
}
