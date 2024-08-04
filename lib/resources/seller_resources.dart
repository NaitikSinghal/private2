import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/report_issue.dart';
import 'package:uuid/uuid.dart';

unFollowSeller(String sellerId) {
  final sellerRef = firebaseFirestore.collection(storeCollection).doc(sellerId);
  firebaseFirestore.runTransaction((transaction) {
    return transaction.get(sellerRef).then((sellerDoc) async {
      transaction.update(sellerRef, {
        "followers": FieldValue.arrayRemove([firebaseAuth.currentUser!.uid])
      });
      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'following': FieldValue.arrayRemove([sellerId])
      });
    });
  }).then(
    (value) => print("DocumentSnapshot successfully updated!"),
    onError: (e) => print("Error updating document $e"),
  );
}

followSeller(String sellerId) {
  final sellerRef = firebaseFirestore.collection(storeCollection).doc(sellerId);
  firebaseFirestore.runTransaction((transaction) {
    return transaction.get(sellerRef).then((sellerDoc) async {
      transaction.update(sellerRef, {
        "followers": FieldValue.arrayUnion([firebaseAuth.currentUser!.uid])
      });

      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'following': FieldValue.arrayUnion([sellerId])
      });
    });
  }).then(
    (value) => print("DocumentSnapshot successfully updated!"),
    onError: (e) => print("Error updating document $e"),
  );
}

addSellerToFavourites(String sellerId) async {
  final favRef = firebaseFirestore
      .collection(favSellerCollection)
      .doc(firebaseAuth.currentUser!.uid);
  firebaseFirestore.runTransaction((transaction) {
    return transaction.get(favRef).then((doc) {
      if (doc.exists) {
        if (doc.data()!['sellers'].contains(firebaseAuth.currentUser!.uid)) {
        } else {
          transaction.update(favRef, {
            'sellers': FieldValue.arrayUnion([sellerId])
          });
        }
      } else {
        transaction.set(favRef, {
          'userId': firebaseAuth.currentUser!.uid,
          'sellers': [sellerId]
        });
      }
    });
  }).then(
    (value) => print("Document successfully updated!"),
    onError: (e) => print("Error updating document $e"),
  );
}

removeSellerFromFavourites(String sellerId) async {
  await firebaseFirestore
      .collection(favSellerCollection)
      .doc(firebaseAuth.currentUser!.uid)
      .update({
    'sellers': FieldValue.arrayRemove([sellerId])
  });
}

reportToSeller(String msg, String sellerId) async {
  try {
    String id = const Uuid().v1();
    ReportIssue issue = ReportIssue(
        id: id,
        reportBy: firebaseAuth.currentUser!.uid,
        reportTo: sellerId,
        issue: msg);
    await firebaseFirestore
        .collection(reportIssueCollection)
        .doc(id)
        .set(issue.toJson());
  } catch (e) {
    print(e);
  }
}
