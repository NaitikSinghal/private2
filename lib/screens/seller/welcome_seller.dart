import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/screens/seller/seller_account.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';

class WelcomeSeller extends StatelessWidget {
  const WelcomeSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/logo/welcome.png'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                'Congratulations',
                style: TextStyle(
                    color: greyScale,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Your seller account has been created',
                  style: TextStyle(color: greyScale),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: RoundButtonWithIcon(
                  height: 46,
                  buttonName: 'Go to account',
                  onPressed: () {
                    Get.off(() => const SellerAccount(),
                        transition: Transition.leftToRight);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
