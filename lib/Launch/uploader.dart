import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Uploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(String filePath, String where) async {
    File file = File(filePath);
    try {
      await _storage.ref().child(where).putFile(file);
      return await _storage.ref().child(where).getDownloadURL();
    } on FirebaseException {
      return null;
    }
  }

  Future<String> getImage(String where) async {
    try {
      return await _storage.ref().child(where).getDownloadURL();
    } on FirebaseException {
      return null;
    }
  }
}
