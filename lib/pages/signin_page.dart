import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/pages/signup_page.dart';
import 'package:fb_auth_provider/providers/signin/signin_provider.dart';
import 'package:fb_auth_provider/providers/signin/signin_state.dart';
import 'package:fb_auth_provider/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  SigninPage({Key? key}) : super(key: key);
  static const String routeName = "/signin";

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    print("email : $_email, password: $_password");

    try {
      await context
          .read<SigninProvider>()
          .signIn(email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }

    /// HomePage로 이동하는 로직이 없어도 된다.
    /// SplashPage에서 authState의 변화를 watch하고 있어,
    /// authState가 authenticated가 되면 HomePage로 이동하는 코드가 실행되기 때문.
  }

  @override
  Widget build(BuildContext context) {
    final signinState = context.watch<SigninProvider>().state;

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset(
                      "assets/images/flutter_logo.png",
                      width: 250,
                      height: 250,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email required";
                        }
                        if (!isEmail(value.trim())) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _email = value;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password required";
                        }
                        if (value.trim().length < 6) {
                          return "Password must be at least characters long";
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _password = value;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : _submit,
                      child: Text(
                        signinState.signinStatus == SigninStatus.submitting
                            ? "Loading..."
                            : "Sign in",
                      ),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, SignupPage.routeName);
                                },
                      child: Text("Not a member? Sign up!"),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
