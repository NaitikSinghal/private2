import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/comment.dart';
import 'package:pherico/models/seller/report_clicky.dart';
import 'package:pherico/resources/user_resource.dart';
import 'package:uuid/uuid.dart';

class ClickyResource {
  static likeReel(String id) async {
    String currentUserId = firebaseAuth.currentUser!.uid;
    DocumentSnapshot doc =
        await firebaseFirestore.collection(clickiesCollection).doc(id).get();

    if ((doc.data() as dynamic)['likes'].contains(currentUserId)) {
      await firebaseFirestore.collection(clickiesCollection).doc(id).update({
        'likes': FieldValue.arrayRemove([currentUserId]),
      });
    } else {
      await firebaseFirestore.collection(clickiesCollection).doc(id).update({
        'likes': FieldValue.arrayUnion([currentUserId]),
      });
    }
  }

  static watched(String id) async {
    await firebaseFirestore
        .collection(clickiesCollection)
        .doc(id)
        .update({'playCount': FieldValue.increment(1)});
  }

  static Future<int> postComment(String commentText, String clickyId) async {
    try {
      final commentId = const Uuid().v1();

      Comment comment = Comment(
        userId: firebaseAuth.currentUser!.uid,
        id: commentId,
        likes: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        comment: commentText,
        username: UserResource.myself.username,
        profile: UserResource.myself.profile,
      );
      await firebaseFirestore
          .collection(clickiesCollection)
          .doc(clickyId)
          .collection(commentCollection)
          .doc(commentId)
          .set(comment.toJson());

      await firebaseFirestore
          .collection(clickiesCollection)
          .doc(clickyId)
          .update({"commentCount": FieldValue.increment(1)});
      return 0;
    } catch (e) {
      return 1;
    }
  }

  static updateComment(
      String commentText, String clickyId, String commentId) async {
    try {
      await firebaseFirestore
          .collection(clickiesCollection)
          .doc(clickyId)
          .collection(commentCollection)
          .doc(commentId)
          .update({'comment': commentText, 'updatedAt': DateTime.now()});
    } catch (e) {
      print(e);
    }
  }

  static likeComment(String clickyId, String commentId) async {
    DocumentSnapshot snapshot = await firebaseFirestore
        .collection(clickiesCollection)
        .doc(clickyId)
        .collection(commentCollection)
        .doc(commentId)
        .get();

    if ((snapshot.data()! as dynamic)['likes']
        .contains(firebaseAuth.currentUser!.uid)) {
      await firebaseFirestore
          .collection(clickiesCollection)
          .doc(clickyId)
          .collection(commentCollection)
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([firebaseAuth.currentUser!.uid])
      });
    } else {
      await firebaseFirestore
          .collection(clickiesCollection)
          .doc(clickyId)
          .collection(commentCollection)
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([firebaseAuth.currentUser!.uid])
      });
    }
  }

  static Future<int> deleteComment(String clickyId, String commentId) async {
    try {
      await firebaseFirestore
          .collection(clickiesCollection)
          .doc(clickyId)
          .collection(commentCollection)
          .doc(commentId)
          .delete();
      await firebaseFirestore
          .collection(clickiesCollection)
          .doc(clickyId)
          .update({'commentCount': FieldValue.increment(-1)});
      return 0;
    } catch (err) {
      return 1;
    }
  }

  static reportClicky(String msg, String sellerId, String clickyId) async {
    try {
      String id = const Uuid().v1();
      ReportClicky issue = ReportClicky(
          id: id,
          reportBy: firebaseAuth.currentUser!.uid,
          reportTo: sellerId,
          reportFor: clickyId,
          issue: msg);
      await firebaseFirestore
          .collection(reportClickyCollection)
          .doc(id)
          .set(issue.toJson());
    } catch (e) {
      print(e);
    }
  }
}
