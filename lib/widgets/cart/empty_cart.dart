import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/screens/home.dart';
import 'package:pherico/screens/main_home.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: Image.asset(
            'assets/images/icons/empty_cart_new.png',
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 10,
          width: 120,
          child: Divider(
            color: Colors.black,
            height: 20,
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Your cart is Empty',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 60,
        ),
        Text.rich(
          TextSpan(
            text: 'Fill it with ',
            children: <InlineSpan>[
              TextSpan(
                text: 'Shop live',
                style: TextStyle(color: gradient2, fontSize: 15),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2 + 50,
          child: RoundButtonWithIcon(
            buttonName: 'Continue Live Shopping',
            onPressed: () {
              Get.to(() => const Home(), transition: Transition.leftToRight);
            },
            height: 55,
          ),
        )
      ],
    );
  }
}
