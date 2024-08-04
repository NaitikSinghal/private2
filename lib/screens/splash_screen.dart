import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/screens/home.dart';
import 'package:pherico/screens/welcome_screen.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (firebaseAuth.currentUser != null) {
        Get.offAll(() => const Home(), transition: Transition.leftToRight);
      } else {
        Get.offAll(() => WelcomeScreen(), transition: Transition.leftToRight);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: HexColor('#1d092c'),
            image: const DecorationImage(
              image: AssetImage('assets/images/bg/Doodle.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(top: 120, bottom: 90),
              child: Image.asset(
                'assets/images/logo/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
