import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUtility {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File imageFile, String storagePath) async {
    try {
      final storageRef = _storage.ref().child(storagePath);

      final uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
