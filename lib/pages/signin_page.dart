import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);
  static const String routeName = "/signin";

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("SignIn"),
      ),
    );
  }
}
