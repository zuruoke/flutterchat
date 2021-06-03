import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

 void uploadImageUrl(String uid, String url) {
  final ref = _firebaseFirestore.collection('users').doc(uid);
  ref.update({
    'photo': url,
  });
}

Future<String> uploadImageToFirebaseStorage({required String id, required PickedFile img, required String folder}) async {
  final String path = "/$id.jpg";
  final Reference ref =  _firebaseStorage.ref().child(folder);
  UploadTask uploadTask = ref.child(path).putFile(File(img.path));
  TaskSnapshot taskSnapshot = await uploadTask;
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}