import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  getUserData() async {
    try {
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      final data = userDoc.data() as dynamic;

      _user.value = {
        'name': data['first_name'] + data['last_name'],
        'profile': data['profile'],
        'email': data['email'],
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'username': data['username'],
        'phone': data['phone'],
        'following': data['following']
      };
      update();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
