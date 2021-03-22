import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Uploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadImage(String filePath, String where) async {
    File file = File(filePath);
    try {
      await _storage.ref().child(where).putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
    return file;
  }

  Future<File> getImage(String where) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    File file = new File('${appDocDir.path}/$where');

    try {
      await _storage.ref().child(where).writeToFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
    return file;
  }
}
