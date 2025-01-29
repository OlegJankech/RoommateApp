import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/scroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: UserController.user != null ? Scroller() : LoginPage(),
        theme: ThemeData(
          primaryColor: CupertinoColors.black,
          colorScheme: ColorScheme.light(
            primary: CupertinoColors.systemGrey.withOpacity(0.79),
            onPrimary: CupertinoColors.white,
            secondary: CupertinoColors.systemBlue,
            onSecondary: CupertinoColors.white,
          ),
        ));
  }
}
