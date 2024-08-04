import 'package:flutter/material.dart';
import 'package:pherico/config/my_color.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class AuthCard extends StatelessWidget {
  final Widget form;
  final String title;
  const AuthCard(
      {required this.form,
      this.title = '',
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: HexColor('#0c1e34'),
        image: const DecorationImage(
          image: AssetImage('assets/images/bg/Doodle.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset(
                    'assets/images/logo/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
               
                  form,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
