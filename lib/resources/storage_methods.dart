import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pherico/config/firebase_constants.dart';

Future<String> uploadImage(
    String childName, Uint8List file, String type) async {
  Reference ref = firebaseStorage.ref();

  if (type == 'profiles') {
    ref = ref.child('profiles').child(childName);
  }

  if (type == 'clickies') {
    ref = ref.child('clickies').child(childName);
  }

  if (type == 'products') {
    ref = ref.child('products').child(childName);
  }

  if (type == 'store_covers') {
    ref = ref.child('store_covers').child(childName);
  }

  if (type == 'covers') {
    ref = ref.child('store_covers').child(childName);
  }

  if (type == 'store_profile') {
    ref = ref.child('store_profile').child(childName);
  }

  if (type == 'chats') {
    ref = ref.child('chats').child(childName);
  }

  if (type == 'lives') {
    ref = ref.child('lives').child(childName);
  }

  UploadTask task = ref.putData(file);

  TaskSnapshot snap = await task;
  return await snap.ref.getDownloadURL();
}

uploadVideo(String caption, String videoPath) {}
