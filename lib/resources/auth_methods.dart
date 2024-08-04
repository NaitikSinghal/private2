
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/resources/storage_methods.dart';
import 'package:pherico/utils/pick_image.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  

  Future<String> signUpUser({
    required String email,
    required String fullName,
    required String phone,
  }) async {

    String res = "Some error occurred";
    try {
        List<String> nameParts = fullName.split(" ");
        String firstName = nameParts[0];
        String lastName = nameParts.length > 1 ? nameParts[1] : "";

      if (email.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          phone.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: "", // No password is required for this sign-up method
        );

        model.User user = model.User(
            email: email.toLowerCase(),
            username: email.split('@')[0],
            uid: cred.user!.uid,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            bio: '',
            followers: [],
            following: [],
            profile: defaultProfile,
            cover: defaultUserCover,
            pushToken: "");

        await _firebaseFirestore
            .collection(usersCollection)
            .doc(cred.user!.uid)
            .set(
              user.toJson(),
            );
        res = "success";
      } else {
        res = "Please provide all required details";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

 
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> registerUser(User user, String email, GoogleSignInAccount googleUser) async {
  // Check if email already exists in Firestore
  // bool isEmailExists = await emailExists(email);

  // if (!isEmailExists) {
    // If email doesn't exist, register the user
    final String firstName = googleUser.displayName!.split(' ').first;
    final String lastName = googleUser.displayName!.split(' ').last;
    final String photourl = googleUser.photoUrl!;
    final String email = googleUser.email;
    // try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: '', 
      );

      model.User user = model.User(
        email: email.toLowerCase(),
        username: email.split('@')[0],
        uid: cred.user!.uid,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        bio: '',
        followers: [],
        following: [],
        profile: photourl,
        cover: defaultUserCover,
        pushToken: '',
      );

      await _firebaseFirestore.collection("users").doc(cred.user!.uid).set(
        user.toJson(),
      );

      print("User registered and details stored successfully!");
  // } 
  // catch (err) {
  //     print("Error registering user: $err");
  //   }

  // }
}
  // Future<String> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final AccessToken accessToken = result.accessToken!;
  //       final String userId = accessToken.userId!;
  //       final userData = await FacebookAuth.instance.getUserData();
  //       final String firstName = userData['first_name'];
  //       final String lastName = userData['last_name'];
  //       final String email = userData['email'];
  //       bool userExists = await emailExists(email);
  //       if (!userExists) {
  //         await registerUser(
  //           firstName: firstName,
  //           lastName: lastName,
  //           email: email,
  //           userId: userId,
  //         );
  //       }
  //       return 'success';
  //     } else if (result.status == LoginStatus.cancelled) {
  //       return "Facebook Sign-In canceled";
  //     } else {
  //       return "Facebook Sign-In failed";
  //     }
  //   } catch (e) {
  //     print("Facebook Sign-In Error: $e");
  //     return "Some error occurred";
  //   }
  // }
  
Future<UserCredential?> signInWithGoogle() async {
  String res = "Some error occurred";
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // return "Google Sign-In canceled";
      return null;
    }
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final UserCredential userCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    ) as UserCredential; // Use 'as' to cast OAuthCredential to UserCredential

    final User user = userCredential.user!;
    final String email = user.email!;
    await registerUser(user, email, googleUser!);
    return await _auth.signInWithCredential(UserCredential as AuthCredential);

  } catch (err) {
    print("Google Sign-In Error: $err");
    return null;
  }
}




   Future<String> signInWithPhoneNumber(String phoneNumber) async {
    String res = "Some error occurred";
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final UserCredential userCredential = await _auth.signInWithCredential(credential);
          res = 'success';
        },
        verificationFailed: (FirebaseAuthException e) {
          res = "Phone number verification failed: ${e.message}";
        },
        codeSent: (String verificationId, int? resendToken) {
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          res = "Phone number verification timeout" ;
        },
      );
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    _auth.signOut();
  }

  static Future<String> updateUserProfileWithImage(Uint8List? file,
      String username, String firstName, String lastName) async {
    String res = 'An error occured';
    try {
      Uint8List image = await compressImage(file!);
      String imageUrl = await uploadImage(const Uuid().v1(), image, 'profiles');

      if (await userExists(username)) {
        res = 'username';
        return res;
      }
      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'profile': imageUrl
      });
      res = 'success';
      return res;
    } catch (error) {
      return res = error.toString();
    }
  }

  static Future<String> updateCover(Uint8List? file) async {
    String res = 'An error occured';
    try {
      Uint8List image = await compressImage(file!);
      String imageUrl = await uploadImage(const Uuid().v1(), image, 'covers');
      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({'cover': imageUrl});
      res = 'success';
      return res;
    } catch (error) {
      return res = error.toString();
    }
  }

  static Future<String> updateUserProfileWithoutImage(
      String username, String firstName, String lastName) async {
    String res = 'An error occured';
    try {
      if (await userExists(username)) {
        res = 'username';
        return res;
      }
      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
      });
      res = 'success';
      return res;
    } catch (error) {
      return res = error.toString();
    }
  }

  static Future<bool> userExists(String username) async =>
      (await firebaseFirestore
                  .collection("users")
                  .where('uid', isNotEqualTo: firebaseAuth.currentUser!.uid)
                  .where("username", isEqualTo: username)
                  .get())
              .docs
              .isEmpty
          ? false
          : true;

  Future<bool> emailExists(String email) async => (await firebaseFirestore
              .collection("users")
              .where('email', isEqualTo: email.toLowerCase())
              .get())
          .docs
          .isEmpty
      ? false
      : true;

  Future<String> sendOtp(String phoneNumber) async {
      String verificationId = "";
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
          
          },
          verificationFailed: (FirebaseAuthException e) {
            print("Failed to send OTP: ${e.message}");
          },
          codeSent: (String verificationId, int? resendToken) {
            verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            verificationId = verificationId;
          },
          timeout: Duration(seconds: 60),
        );
      } catch (e) {
        print("Error sending OTP: $e");
      }
      return verificationId;
    }

  Future<bool> verifyOtp(String verificationId, String otpCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      UserCredential authResult= await _auth.signInWithCredential(credential);
       User? user = authResult.user;
       if (user != null) {
        return true;
        } else {
          return false;
        }
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }



  Future<void> savePhoneNumberToDatabase(String userId, String mobileNumber) async {
    try {
      await firebaseFirestore.collection("users").doc(userId).update({
        "phoneNumber": mobileNumber,
      });
      print("Phone number saved to database successfully!");
    } catch (e) {
      print("Error saving phone number to database: $e");
    }
  }

  Future<String> sendPasswordResetCode({
    required String email,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email.trim());
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String?> getCurrentUserId() async {
  try {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  } catch (e) {
    print("Error getting current user id: $e");
    return null;
  }
}

}
