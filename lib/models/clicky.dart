import 'package:cloud_firestore/cloud_firestore.dart';

class Clicky {
  String sellerName;
  String userId;
  String id;
  List likes;
  int commentCount;
  int likesCount;
  int playCount;
  String caption;
  String videoUrl;
  String thumbnail;
  String profile;
  List productIds;
  final createdAt;
  final updatedAt;

  Clicky(
      {required this.sellerName,
      required this.userId,
      required this.id,
      required this.likes,
      required this.commentCount,
      required this.likesCount,
      required this.playCount,
      required this.caption,
      required this.videoUrl,
      required this.thumbnail,
      required this.profile,
      required this.productIds,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toJson() => {
        "sellerName": sellerName,
        "userId": userId,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "likesCount": likesCount,
        "playCount": playCount,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumnail": thumbnail,
        "profile": profile,
        "productIds": productIds,
        "createdAt": createdAt,
        "updatedAt": updatedAt
      };

  static Clicky fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Clicky(
        sellerName: snapshot['sellerName'],
        userId: snapshot['userId'],
        id: snapshot['id'],
        likes: snapshot['likes'],
        commentCount: snapshot['commentCount'],
        likesCount: snapshot['likesCount'],
        playCount: snapshot['playCount'],
        caption: snapshot['caption'],
        videoUrl: snapshot['videoUrl'],
        thumbnail: snapshot['thumnail'],
        profile: snapshot['profile'],
        productIds: snapshot['productIds'],
        createdAt: snapshot['createdAt'],
        updatedAt: snapshot['updatedAt']);
  }

  factory Clicky.fromMap(Map<String, dynamic> json) {
    return Clicky(
      sellerName: json['sellerName'],
      userId: json['userId'],
      id: json['id'],
      likes: json['likes'],
      commentCount: json['commentCount'],
      likesCount: json['likesCount'],
      playCount: json['playCount'],
      caption: json['caption'],
      videoUrl: json['videoUrl'],
      thumbnail: json['thumnail'],
      profile: json['profile'],
      productIds: json['productIds'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
