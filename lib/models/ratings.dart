import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final int rate;
  final String review;
  final String name;
  final String profile;
  final String userId;
  final String ratingAt;

  Rating(
      {required this.rate,
      required this.review,
      required this.name,
      required this.profile,
      required this.ratingAt,
      required this.userId});

  factory Rating.fromMap(Map<String, dynamic> json) {
    return Rating(
      name: json['name'],
      rate: json["rate"],
      userId: json["userId"],
      review: json["review"],
      profile: json["profile"],
      ratingAt: json["ratingAt"],
    );
  }

  static Rating fromJson(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Rating(
      name: snap['name'],
      rate: snap['rate'],
      userId: snap['userId'],
      review: snap['review'],
      profile: snap['profile'],
      ratingAt: snap['ratingAt'],
    );
  }
}
