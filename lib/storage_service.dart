import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  List<String> _imageUrls = [];

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFile() async {
    firebase_storage.ListResult result = await storage.ref('test').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print('List intance ${result}');
    });
    return result;
  }

  // Future<String> downloadURL(String imageName) async {
  //   String downloadURL = await storage
  //       .ref(
  //           'test/data/user/0/com.example.fruits_applicatiopn/cache/file_picker/$imageName')
  //       .getDownloadURL();
  //   return downloadURL;
  // }

  Future<void> getImages() async {
    try {
      final ListResult result = await storage.ref().child('test/').listAll();
      final List<String> urls = [];
      for (final Reference ref in result.items) {
        final String url = await ref.getDownloadURL();
        urls.add(url);
      }

      _imageUrls = urls;
    } catch (e) {
      print('Error loading images: $e');
    }
  }
}
