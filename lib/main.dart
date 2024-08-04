import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:pherico/blocs/internet/internet_bloc.dart';
import 'package:pherico/controllers/auth_controller.dart';
import 'package:pherico/widgets/global/global_dialog.dart';
import 'screens/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA4HbT726Ehmb-n0pfLOZXLM67LFnGlgV8",
        appId: "1:315583696265:android:c36e4b17c6ae3637902558",
        messagingSenderId: "315583696265",
        projectId: "pherico-4a1e4",
        storageBucket: "pherico-4a1e4.appspot.com",
      ),
    ).then((value) {
      Get.put(AuthController());
    });
  } else {
    await Firebase.initializeApp();
  }

  await FlutterNotificationChannel.registerNotificationChannel(
    id: 'chats',
    name: 'chats',
    description: 'For showing message notification',
    importance: NotificationImportance.IMPORTANCE_HIGH,
  );
  runApp(const MyApp());
}

Future initialization(BuildContext? context) async {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: GetMaterialApp(
        key: GlobalDialog.dialogNavigatorKey,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        // onGenerateRoute: (RouteSettings settings) {
        //   var routes = <String, WidgetBuilder>{
        //     "product-details": (ctx) =>
        //         ProductDetails(settings.arguments as String)
        //   };
        //   WidgetBuilder? builder = routes[settings.name];
        //   return MaterialPageRoute(builder: (ctx) => builder!(ctx));
        // },
      ),
    );
  }
}
