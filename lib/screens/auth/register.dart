import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_page;
import 'package:pherico/config/my_color.dart';
import 'package:pherico/screens/auth/login.dart';
import 'package:pherico/screens/auth/phone_number.dart';
import 'package:pherico/screens/auth/verification.dart';
import 'package:pherico/widgets/auth/auth_input.dart';
import 'package:pherico/widgets/auth/auth_submit_button.dart';
import '../../config/icon_paths.dart';
import '../../resources/auth_methods.dart';
import '../home.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late int currentPage = 0;
  bool hidePassword = true;
  bool chidePassword = true;
  bool isApiCallProcess = false;
  String error = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

 Future<String> signUpUser({
    required TextEditingController email,
    required TextEditingController fullName,
    required TextEditingController phone
    }) async {
   print("signup called");
    String res = "some error occured";
    String result = await signUpUser(
      email: email,
      fullName: fullName,
      phone: phone,
    );
    if (result == "success") {
      print("in if ");
      get_page.Get.to(() => Verification(phoneNumber: _phoneNumberController,),
      transition:get_page.Transition.leftToRight);
      return res = "successfully signed up";
    }
     else {
       print("in else block");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      print('Signup error');
      return res = "signup error";
    }
  }

  bool isEmailExists = false;
  Map<String, String> loginData = {'phone number': ''};
  late int enteredOtp = 2;
  final GlobalKey<FormState> _globalKey = GlobalKey();
  String title = 'Sign up';
  String subtitle1 = "Sign up in pherico by providing us your name & mobile number";
  double deviceHeight = 0;

  Future<void> signInWithGoogle() async {
    try {
      final AuthMethods authMethods = AuthMethods();
        await authMethods.signInWithGoogle();
        print('login done');
        get_page.Get.to(() => const PhoneNumber(),
        transition:get_page.Transition.rightToLeft);
    } catch (e) {
      print("Google Sign-In Error: $e");
      }
  }
  @override
Widget build(BuildContext context) {
  deviceHeight = MediaQuery.of(context).size.height;
  return Scaffold(
    body: SafeArea(
      child: Column(
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
                padding:  const EdgeInsets.only(left: 10.0, right: 10.0),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 0, left: 10, right: 10),
                      child: AuthInput(
                        controller: _fullNameController,
                        keyName: "name",
                        onValidate: () {},
                        onSaved: () {},
                        hint: "Full name",
                        prefixIcon: const Icon(Icons.account_circle),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 10, right: 10),
                      child: AuthInput(
                        isNumeric: true,
                        controller: _phoneNumberController,
                        keyName: 'phone number',
                        onValidate: () {},
                        onSaved: () {},
                        hint: "+91 | Your phone number",
                        prefixIcon: const Icon(Icons.call),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 15, left: 10, right: 10),
                      child: AuthInput(
                        controller: _emailController,
                        keyName: 'Email',
                        onValidate: () {},
                        onSaved: () {},
                        hint: "Your email id",
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                 
                    Padding(
                      padding: const EdgeInsets.only( top:10, bottom:20),
                      child: AuthSubmitButton(
                        buttonName: 'SIGN UP',
                        onSubmit: ()  {
                          signUpUser(email: _emailController, fullName: _fullNameController, phone: _phoneNumberController);
                            // get_page.Get.to(() =>  const Verification(verificationId: ''),
                            // transition: get_page.Transition.leftToRight);
                          // if (validateAndSave()) {
                          //   setState(() {
                          //     error = '';
                          //   });
                          //   if (loginData['phone number']!.length <= 10) {
                          //     setState(() {
                          //       error = 'Please Enter Phone Number';
                          //     });
                          //   }
                          //   else if (!loginData['phone number']!.contains('@')) {
                          //     setState(() {
                          //       error = 'Please Enter Valid Phone number';
                          //     });
                          //   } 
                          //   else if (loginData['password']!.length < 6) {
                          //     setState(() {
                          //       error = 'Please Enter Valid Password';
                          //     });
                          //   } else {
                          //     setState(() {
                          //       error = '';
                          //       isApiCallProcess = true;
                          //     });
                          //     String res = await AuthMethods().loginUser(
                          //         email: loginData['email']!,
                          //         password: loginData['password']!);
                          //     if (res != 'success') {
                          //       setState(() {
                          //         error = res.split(']')[1];
                          //         isApiCallProcess = false;
                          //       });
                          //     } else {
                          //       setState(() {
                          //         error = '';
                          //         isApiCallProcess = false;
                          //       });
                              
                          //     }
                          //   }
                          // }
                        },
                      ),
                    ), 
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("OR", style: TextStyle(fontWeight: FontWeight.w500, color: labelGreyColor, fontSize: 20)),
                      ),
                    ),                                     
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: (){
                        signInWithGoogle();
                      },
                        child: LoginOption(imagePath: googleIcon, title: "Signup with Google")),
                    const SizedBox(height: 8),
                    LoginOption(imagePath: facebookIcon, title: "Signup with Facebook"),
                    const SizedBox(height: 25),
                        
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text: "Already have an account?  ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Log in',
                              style: TextStyle(
                                fontSize: 16,
                                color: blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  get_page.Get.to(() => const Login(), transition: get_page.Transition.rightToLeft);
                                },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  bool validateAndSave() {
    final form = _globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}


//   Widget namesCard() {
//     return Form(
//       key: nameKey,
//       child: Column(
//         children: [
//           AuthInput(
//             label: 'First Name',
//             keyName: 'first_name',
//             hint: 'Enter First Name',
//             onValidate: (onValidate) {
//               if (onValidate.isEmpty || onValidate.length < 4) {
//                 return 'Please enter first name';
//               }
//               return null;
//             },
//             onSaved: (onSaved) {
//               _registerData['first_name'] = onSaved;
//             },
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           AuthInput(
//             label: 'Last Name',
//             keyName: 'last_name',
//             hint: 'Enter Last Name',
//             onValidate: (onValidate) {
//               if (onValidate.isEmpty || onValidate.length < 3) {
//                 return 'Please enter last name';
//               }
//               return null;
//             },
//             onSaved: (onSaved) {
//               _registerData['last_name'] = onSaved;
//             },
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           AuthSubmitButton(
//             buttonName: 'Proceed',
//             onSubmit: () {
//               if (validateName()) {
//                 setState(() {
//                   currentPage++;
               
//                 });
//               }
//             },
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           RichText(
//             text: TextSpan(
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 14,
//               ),
//               children: [
//                 const TextSpan(text: "Already have an account with us? "),
//                 TextSpan(
//                   text: 'Login',
//                   style: TextStyle(
//                     color: gradient1,
//                     decoration: TextDecoration.underline,
//                   ),
//                   recognizer: TapGestureRecognizer()
//                     ..onTap = () {
//                       Navigator.pushNamed(context, '/login');
//                     },
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }

  // bool validateName() {
  //   final form = nameKey.currentState;
  //   if (form!.validate()) {
  //     form.save();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // bool validatePhoneAndEmail() {
  //   final form = _phoneEmailKey.currentState;
  //   if (form!.validate()) {
  //     form.save();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }



class LoginOption extends StatelessWidget {
 
  final String imagePath;
  final String title;

  LoginOption({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 35,right: 35),
      decoration: BoxDecoration(
        color: white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
           BoxShadow(
                color: shadowColorInput.withOpacity(0.1), // Shadow color
                spreadRadius: 1, // Spread radius of the shadow
                blurRadius: 5, // Blur radius of the shadow
                offset: const Offset(0, 1), // Offset of the shadow
              ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:40.0,right: 10,top:8,bottom:8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              height: 30,
              width: 30,
              child: Image.asset(imagePath,fit: BoxFit.cover,)),
            const SizedBox(width: 20,),
            Text(title, style: TextStyle(color: black,fontWeight: FontWeight.w400, fontSize: 17),)
          ],
        ),
      ),
    );
  }
}