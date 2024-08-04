import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/screens/auth/Login.dart';
import 'package:pherico/screens/home.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const Login());
    } else {
      Get.offAll(() => const Home());
    }
  }
}
