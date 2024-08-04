import 'dart:async';
import 'package:get/get.dart' as get_page;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/screens/auth/phone_number.dart';
import 'package:pherico/screens/home.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/auth/auth_submit_button.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import '../../config/my_color.dart';
import '../../config/variables.dart';
import '../../resources/auth_methods.dart';
import 'package:get/get.dart';


class Verification extends StatefulWidget {
  final TextEditingController phoneNumber;
  const Verification({super.key,required this.phoneNumber,});
  
  @override
  State<Verification> createState() => _VerificationState();
  
}

class _VerificationState extends State<Verification> {
  late Timer _timer;
  int _start = 60;
  double deviceHeight = 0;
  String title = 'Verification';
  String? _verificationId;
  String subtitle1 = "We've send you the verification code on +12620 0323 7631";
  TextEditingController _otpController = TextEditingController();
  
  String get phoneNumber => phoneNumber;
  @override
  void initState() {
    super.initState();
    startTimer();
    sendOtp();
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
    void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  Future<void> sendOtp() async {
    String verificationId = await AuthMethods().sendOtp(phoneNumber);
    if (verificationId.isNotEmpty) {
      setState(() {
        _verificationId = verificationId;
      });
    } else {
      print("Failed to send OTP");
    }
  }

  void verifyOtp() async {
    String otpCode = _otpController.text.trim();
    bool isVerified = await AuthMethods().verifyOtp(_verificationId!, otpCode);
    if (isVerified) {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      await AuthMethods().savePhoneNumberToDatabase(userId, phoneNumber);
      get_page.Get.offAll(() => const Home());
    } else {
      print("OTP verification failed");
    }
  }

  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Container(
              height:deviceHeight,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  const SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.center,
                      child: Pinput(
                          length: 4,
                          defaultPinTheme: PinTheme(
                            width: 65,
                            height: 65,
                            textStyle: const TextStyle(fontSize: 25),
                            decoration: BoxDecoration(
                              border: Border.all(color: labelGreyColor),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                      
                            )
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please enter otp';
                            }
                            if(text.length<=3) {
                              return 'Please enter a valid otp';
                            }
                            return null;
                            },
                          onChanged: (value) {},
                          showCursor: true,
                          onCompleted: (pin) => _otpController.text = pin,
                      ),
                    ),
                    const SizedBox(height: 20,),

                 Padding(
                   padding: const EdgeInsets.only(left:10.0,right:10,top:5, bottom:15),
                   child: AuthSubmitButton(buttonName: 'CONTINUE',
                    onSubmit: () async{
                      verifyOtp();
                   }),
                 ),
                 const SizedBox(height:15),
                 Align(
                  alignment: Alignment.center,
                   child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "Re-send code in "),
                        _start == 0
                            ? TextSpan(
                                text: 'Resend code',
                                style: TextStyle(
                                  color: blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    setState(() {
                                      _start = 20;
                                      startTimer();
                                    });
                                    context.showToast('Otp sent');
                                    await AuthMethods()
                                        .sendPasswordResetCode(email: email.tr);
                                  },
                              )
                            : TextSpan(
                                text: _start.toString(),
                                style: TextStyle(
                                  color: blue,
                                ),
                              )
                      ],
                    ),
                  ),
                 ),
                ],
              ),
            )
          )

        ],
      )),
    );
  }

  
  
}
