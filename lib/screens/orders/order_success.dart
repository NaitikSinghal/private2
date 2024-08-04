import 'package:flutter/material.dart';
import 'package:pherico/widgets/buttons/round_button_with_icon.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class OrderSuccess extends StatelessWidget {
  static const routeName = '/order-success';
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                width: 110,
                child: Image.asset(
                  'assets/images/icons/success.png',
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Your order has been received',
                style: TextStyle(
                    fontSize: 20,
                    color: HexColor('311B02'),
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 6, 32, 12),
                child: Text(
                  'You would be notify when your order is on it way',
                  style: TextStyle(color: HexColor('#919496'), fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(32, 6, 32, 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Id',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '2343edasd',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 + 50,
                child: RoundButtonWithIcon(
                  buttonName: 'Continue Live Shopping',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                  height: 55,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
