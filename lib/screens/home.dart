import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pherico/blocs/internet/internet_bloc.dart';
import 'package:pherico/blocs/internet/internet_state.dart';
import 'package:pherico/config/icon_paths.dart';
import 'package:pherico/config/my_color.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/resources/user_resource.dart';
import 'package:pherico/screens/cart_screen.dart';
import 'package:pherico/screens/category.dart';
import 'package:pherico/screens/clicky/clickies.dart';
import 'package:pherico/screens/main_home.dart';
import 'account.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List pages = [
    const MainHome(),
    const Clickies(),
    const Category(),
    const CartScreen(),
    const Account()
  ];

  int currentPage = 0;

  void onTap(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    UserResource.getUserInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        ChatResource.updateStatus(true);
      }
      if (message.toString().contains('pause')) {
        ChatResource.updateStatus(false);
      }

      return Future.value(message);
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {});
    // Future.delayed(Duration.zero, () {
    //   showLiveRequestDialog();
    // });
  }

  late DateTime backPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(backPressTime) > const Duration(seconds: 2)) {
      backPressTime = now;
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text('Double press to exit')));
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return BlocConsumer<InternetBloc, InternetState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          body: DoubleBackToCloseApp(
            child: pages[currentPage],
            snackBar: const SnackBar(
              content: Text('Double tap to exit'),
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 245, 245, 245),
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(20),
              //   topRight: Radius.circular(20),
              // ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Column(
                      children: [
                        IconButton(
                          enableFeedback: false,
                          onPressed: () {
                            setState(() {
                              currentPage = 0;
                            });
                          },
                          icon: SvgPicture.asset(
                              currentPage == 0 ? homeActive : homeInActive),
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                              height: -0.001,
                              fontSize: 12,
                              color: currentPage == 0 ? gradient1 : iconColor),
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Column(
                      children: [
                        IconButton(
                          enableFeedback: false,
                          onPressed: () {
                            setState(() {
                              currentPage = 1;
                            });
                          },
                          icon: SvgPicture.asset(
                              currentPage == 1 ? clickActive : clickInActive),
                        ),
                        Text(
                          'Clickies',
                          style: TextStyle(
                              height: -0.001,
                              fontSize: 12,
                              color: currentPage == 1 ? gradient1 : iconColor),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          enableFeedback: false,
                          onPressed: () {
                            setState(() {
                              currentPage = 3;
                            });
                          },
                          icon: SvgPicture.asset(
                              currentPage == 3 ? cartActive : cartInActive),
                        ),
                        Text(
                          'Cart',
                          style: TextStyle(
                              height: -0.001,
                              fontSize: 12,
                              color: currentPage == 3 ? gradient1 : iconColor),
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.06,
                    ),
                    Column(
                      children: [
                        IconButton(
                          enableFeedback: false,
                          onPressed: () {
                            setState(() {
                              currentPage = 4;
                            });
                          },
                          icon: SvgPicture.asset(currentPage == 4
                              ? accountActive
                              : accountInActive),
                        ),
                        Text(
                          'Account',
                          style: TextStyle(
                              height: -0.001,
                              fontSize: 12,
                              color: currentPage == 4 ? gradient1 : iconColor),
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ],
                )
              ],
            ),
          ),
          resizeToAvoidBottomInset: true,
          floatingActionButton: Visibility(
            visible: !keyboardIsOpen,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  currentPage = 2;
                });
              },
              child: Image.asset(
                'assets/images/navigation-icon/livepng.png',
                height: 65,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
        );
      },
      listener: (context, state) {
        if (state is InternetGainedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Internet connected'),
              backgroundColor: green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Internet disconected'),
              backgroundColor: red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }
}
