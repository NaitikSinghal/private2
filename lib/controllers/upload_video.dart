import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/clicky.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:get/get.dart';

class UploadVideoController extends GetxController {
  Future<String> uploadClickies(
      String caption, List<String> productIds, String videoPath) async {
    String res = 'Error occured';
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firebaseFirestore.collection(storeCollection).doc(uid).get();
      var id = const Uuid().v1();
      String name = (userDoc.data()! as Map<String, dynamic>)['shopName'];

      String url = await _storeClickies(videoPath, id);
      String thumbnail = await _uploadThumbnail(videoPath, id);
      Clicky clicky = Clicky(
          sellerName: name,
          userId: uid,
          id: id,
          likes: [],
          commentCount: 0,
          likesCount: 0,
          playCount: 0,
          caption: caption,
          videoUrl: url,
          thumbnail: thumbnail,
          profile: (userDoc.data()! as Map<String, dynamic>)['profile'],
          productIds: productIds,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch);

      await firebaseFirestore
          .collection('clickies')
          .doc(id)
          .set(clicky.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> _storeClickies(String videoPath, String id) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  Future<String> _uploadThumbnail(String videoPath, String id) async {
    Reference ref =
        firebaseStorage.ref().child('clickies_thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _generateThumbnail(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  _generateThumbnail(String videoPath) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnailFile;
  }
}
