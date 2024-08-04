import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/user.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/resources/firebase_messaging.dart';

class UserResource {
  static late User myself;
  static Future<void> getUserInfo() async {
    await firebaseFirestore
        .collection(usersCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        myself = User.fromSnap(user);
        await FirebaseMessaggin.getFirebaseMessagingToken();
        ChatResource.updateStatus(true);
      }
    });
  }
}
