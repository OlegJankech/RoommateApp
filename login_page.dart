import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/scroller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGrey.withOpacity(0.6),
        ),
        child: Center(
            child: CupertinoButton(
          child: const Text("Login"),
          onPressed: () async {
            try {
              final user = await UserController.loginWithGoogle();
              if (user != null && mounted) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Scroller()));
              }
            } on FirebaseAuthException catch (error) {
              print(error.message);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.message ?? "something went wrong")));
            } catch (error) {
              print(error);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())));
            }
          },
        )));
  }
}
