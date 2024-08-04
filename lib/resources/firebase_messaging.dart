import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/resources/store_registration.dart';

class FirebaseMessaggin {
  static Future<void> getFirebaseMessagingToken() async {
    try {
      await firebaseMessaging.requestPermission();

      await firebaseMessaging.getToken().then((token) async {
        if (token != null) {
          await firebaseFirestore
              .collection(usersCollection)
              .doc(firebaseAuth.currentUser!.uid)
              .update({'pushToken': token});
          if (await StoreRegistration.sellerRegistered()) {
            await firebaseFirestore
                .collection(storeCollection)
                .doc(firebaseAuth.currentUser!.uid)
                .update({'pushToken': token});
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
