import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/screens/auth/Login.dart';
import 'package:pherico/screens/auth/Register.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/splash/slider_1.dart';
import 'package:pherico/widgets/splash/slider_2.dart';
import 'package:pherico/widgets/splash/slider_3.dart';

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  static const routeName = '/splash';
  WelcomeScreen({super.key});

  List slider = [const Slider1(), const Slider2(), const Slider3()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const Login(),
                            transition: Transition.leftToRight);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: gradient1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.loose(
                Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.50),
              ),
              child: Swiper(
                autoplay: true,
                autoplayDelay: 5000,
                outer: false,
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    activeColor: gradient1,
                    color: labelGreyColor,
                  ),
                ),
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (ctx, i) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 6.0,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 64,
                        child: slider[i],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: GradientElevatedButton(
                buttonName: 'Login',
                onPressed: () {
                  Get.to(() => const Login(),
                      transition: Transition.leftToRight);
                },
                height: 50,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => const Register(),
                    transition: Transition.leftToRight);
              },
              child: Text(
                'Create account',
                style: TextStyle(color: gradient2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
