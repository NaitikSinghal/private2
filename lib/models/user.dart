import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String bio;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final List followers;
  final List following;
  final String profile;
  final String cover;
  final String pushToken;

  User(
      {required this.uid,
      required this.bio,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.followers,
      required this.following,
      required this.profile,
      required this.cover,
      required this.username,
      required this.pushToken});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "bio": bio,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "followers": followers,
        "following": following,
        "profile": profile,
        "cover": cover,
        "username": username,
        "pushToken": pushToken
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        uid: snapshot['uid'],
        bio: snapshot['bio'],
        firstName: snapshot['first_name'],
        lastName: snapshot['last_name'],
        email: snapshot['email'],
        phone: snapshot['phone'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        profile: snapshot['profile'],
        cover: snapshot['cover'],
        username: snapshot['username'],
        pushToken: snapshot['pushToken']);
  }
}
