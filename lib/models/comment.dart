import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String comment;
  final String id;
  final String userId;
  final List likes;
  final String profile;
  final createdAt;
  final updatedAt;

  Comment(
      {required this.userId,
      required this.id,
      required this.likes,
      required this.createdAt,
      required this.comment,
      required this.username,
      required this.profile,
      required this.updatedAt});

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "likes": likes,
        "comment": comment,
        "username": username,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "profile": profile,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
        userId: snapshot['userId'],
        id: snapshot['id'],
        likes: snapshot['likes'],
        comment: snapshot['comment'],
        username: snapshot['username'],
        profile: snapshot['profile'],
        createdAt: snapshot['createdAt'],
        updatedAt: snapshot['updatedAt']);
  }
}
