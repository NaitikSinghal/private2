import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:account_picker/account_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as get_page;
import 'package:pherico/blocs/internet/internet_bloc.dart';
import 'package:pherico/blocs/internet/internet_state.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/icon_paths.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/variables.dart';
import 'package:pherico/resources/auth_methods.dart';
import 'package:pherico/screens/auth/Register.dart';
import 'package:pherico/screens/auth/phone_number.dart';
import 'package:pherico/screens/auth/verification.dart';
import 'package:pherico/screens/home.dart';
import 'package:pherico/utils/snackbar.dart';
import 'package:pherico/widgets/auth/auth_card.dart';
import 'package:pherico/widgets/auth/auth_input.dart';
import 'package:pherico/widgets/auth/auth_submit_button.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';


class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  String error = '';
  final GlobalKey<FormState> _globalKey = GlobalKey();
    final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Map<String, String> loginData = {'phone number': '', 'email': '',};
  
  Future<void> signInWithGoogle() async {
    print("signinwithgoogle called");
    try {
      final AuthMethods authMethods = AuthMethods();
        await authMethods.signInWithGoogle();
        print('login done');
        get_page.Get.to(() => PhoneNumber(),
        transition:get_page.Transition.leftToRight);
    } catch (e) {
      print("Google Sign-In Error: $e");
      }
  }
    @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
  }
    Future<void> signInWithPhoneNumber() async {
    String phoneNumber = '+91${_phoneNumberController.text.trim()}';
   
    String verificationId = await AuthMethods().signInWithPhoneNumber(phoneNumber);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: ProgressHUD(
              inAsyncCall: isApiCallProcess,
              key: UniqueKey(),
              opacity: 0.3,
              child: Stack(
                children: [
                  AuthCard(
                    form: authCard(context),
                   
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is InternetGainedState) {
          showSnackbar('Connected', context);
        } else {
          showErrorSnackbar('Disconected', context);
        }
      },
    );
  }

  Widget authCard(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          error.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                    overflow: TextOverflow.visible,
                  ),
                )
              : Container(),
          const Padding(
            padding: EdgeInsets.only(left:17.0,),
            child: Text("Log in", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 0),
            child: AuthInput(
              controller: _phoneNumberController,
              isNumeric: true,
              keyName: 'phone number or email',
              hint: 'Enter your phone number or email',
             prefixIcon: const Icon(Icons.call),
              onValidate: (onValidate) {
                if (onValidate.isEmpty)  {
                  return 'Please enter phone number';
                }
                return null;
              },
              onSaved: (onSavedVal) {
                loginData['email'] = onSavedVal;
              },
              
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 10, left: 10, right: 10),
            child: AuthInput(
              controller: _passwordController,
              keyName: 'password',
              hint: 'Enter Password',
              type: 'password',
              prefixIcon: const Icon(Icons.key),
              hidePassword: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: greyColor,
                icon:
                    Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
              ),
              onValidate: (onValidate) {
                if (onValidate.isEmpty || onValidate.length < 6) {
                  return 'Please enter valid password';
                }
                return null;
              },
              onSaved: (onSaved) {
                password = onSaved;
              },
            ),
          ),

       

          Padding(
            padding: const EdgeInsets.only( top:10, bottom:20),
            child: AuthSubmitButton(
              buttonName: 'LOG IN',
              onSubmit: ()  {
                  signInWithPhoneNumber();
              },
            ),
          ),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.center,
            child: Text("OR", style: TextStyle(fontWeight: FontWeight.w500,color: labelGreyColor,fontSize: 20),),
          ),
          const SizedBox(height: 20,),

          InkWell(
            onTap: (){
              signInWithGoogle();
            },
            child: LoginOption(imagePath: googleIcon, title: "Login with Google",controller: _emailController,)),
          const SizedBox(height: 8,),
          LoginOption(imagePath: facebookIcon, title: "Login with Facebook",controller: _emailController,),
          
          
          const SizedBox(
            height: 20,
          ),

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
                    text: "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign up',
                    style: TextStyle(
                      fontSize: 16,
                      color: blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        get_page.Get.to(() => const Register(),
                            transition: get_page.Transition.leftToRight);
                      },
                  )
                ],
              ),
            ),
          ),
        ],
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
class LoginOption extends StatelessWidget {
 
  final String imagePath;
  final String title;
 
  final TextEditingController controller;
 
  LoginOption({
   required this.imagePath,
   required this.title,
   required this.controller,

   });

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
