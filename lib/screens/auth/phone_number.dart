import 'package:flutter/material.dart';
import 'package:pherico/screens/auth/verification.dart';
import 'package:get/get.dart' as get_page;
import 'package:pherico/screens/home.dart';
import '../../config/my_color.dart';
import '../../resources/auth_methods.dart';
import '../../widgets/auth/auth_input.dart';
import '../../widgets/auth/auth_submit_button.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});
  
  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {

  String title = 'Verify Phone number';
  String subtitle1 = "Please enter your phone number for verification!";

  final TextEditingController _phoneNumberController = TextEditingController();
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
            padding: const EdgeInsets.only(left: 15,top: 10,bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black)),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0, right:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 80, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 27)),
                            const SizedBox(height: 10),
                            Text(subtitle1, style: const TextStyle(fontSize: 17)),
                          ],
                        ),
                      ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 10, right: 10),
                          child: AuthInput(
                            controller: _phoneNumberController,
                            isNumeric: true,
                            keyName: 'phone number',
                            onValidate: () {},
                            onSaved: () {},
                            hint: "+91 | Your phone number",
                            prefixIcon: const Icon(Icons.call),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only( top:10, bottom:20),
                          child: AuthSubmitButton(
                            buttonName: 'CONFIRM',
                            onSubmit: ()  {
                                 get_page.Get.to(() => Verification(phoneNumber: _phoneNumberController,),
                                  transition: get_page.Transition.leftToRight);
                            }
                          )
                        )
                  ],
                ),
              ),
            )
          )
        ],
      )
    ),
  );
  }
}