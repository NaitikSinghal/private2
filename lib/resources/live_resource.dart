import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/live_model.dart';
import 'package:pherico/resources/storage_methods.dart';
import 'package:pherico/utils/pick_image.dart';
import 'package:uuid/uuid.dart';

class LiveResource {
  static Future<bool> goLive(
      {required liveId,
      required String hostName,
      required String liveTitle,
      required String hostProfile,
      required List productIds,
      required String categoryId,
      required Uint8List thumbnail}) async {
    bool res = false;
    try {
      Uint8List image = await compressImage(thumbnail);
      String thumbnailImage =
          await uploadImage(const Uuid().v1(), image, 'lives');
      LiveModel data = LiveModel(
        docId: liveId,
        liveId: liveId,
        isLive: true,
        hostName: hostName,
        thumbnail: thumbnailImage,
        members: [],
        hostId: firebaseAuth.currentUser!.uid,
        liveTitle: liveTitle,
        hostProfile: hostProfile,
        startedAt: DateTime.now().millisecondsSinceEpoch.toString(),
        endedAt: '',
        totalJoined: 0,
        products: productIds,
        liveCategory: categoryId,
      );
      firebaseFirestore
          .collection(liveCollection)
          .doc(liveId)
          .set(data.toJson());
      res = true;
    } catch (e) {
      res = false;
    }

    return res;
  }

  static Future<void> endLive({
    required docId,
  }) async {
    try {
      await firebaseFirestore.collection(liveCollection).doc(docId).update(
          {'isLive': false, 'endedAt': DateTime.now().millisecondsSinceEpoch});
    } catch (e) {}
  }

  static Future<void> saveJoinUser({required docId, required userId}) async {
    try {
      await firebaseFirestore.collection(liveCollection).doc(docId).update({
        'members': FieldValue.arrayUnion([userId]),
        'totalJoined': FieldValue.increment(1)
      });
    } catch (e) {}
  }
}
