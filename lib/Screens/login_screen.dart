import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/Services/Auth/auth_exception.dart';
import 'package:notes/Services/Auth/auth_service.dart';

import '../Utilities/input_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'dart:developer' as devtools show log;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final LocalAuthentication auth;
  late final bool canAuthenticateWithBiometrics;
  late final bool canAuthenticate;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Biometrics.canAuthenticateWithBiometrics();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  bool showBiometrics = false;
  bool isAuthenticated = false;
  bool biometricsAvialable = false;
  bool isLoading = false;
  bool LoginSuccessfull = false;

  String email = "";
  String password = "";

  bool emailIsValid = true;
  bool emailIsEmpty = false;
  bool passwordIsValid = true;

  bool passwordIsEmpty = false;
  String text = "";
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              "assets/images/register.png",
              height: 280,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: TextField(
                onChanged: (value) {
                  if (value.contains("@")) {
                    setState(() {
                      emailIsValid = true;
                    });
                  }
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Enter Email",
                    errorText:
                        emailIsValid ? null : "Please input a valid email"),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: TextFormField(
                onChanged: (value) {
                  if (value.length > 8) {
                    setState(() {
                      password = value;
                      passwordIsValid = true;
                    });
                  }
                },
                enableSuggestions: false,
                autocorrect: false,
                obscureText: !isVisible,
                controller: _passwordController,
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        child: Icon(
                          !isVisible ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(255, 98, 71, 230),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Enter Password",
                    errorText: passwordIsValid ? null : "Password too short"),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  email = _emailController.text;
                  password = _passwordController.text;

                  final validate = InputValidator(
                    email: email,
                    password: password,
                  );

                  final loginFormIsValid = validate.loginFormIsValid();
                  if (loginFormIsValid) {
                    try {
                      final userCredentials = await AuthService.firebase()
                          .login(email: email, password: password);

                      setState(() {
                        LoginSuccessfull = true;
                      });
                      if (LoginSuccessfull) {
                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return ClassicGeneralDialogWidget(
                                titleText: 'Login Successfull.',
                                contentText: 'You have been logged in.',
                                // onPositiveClick: () {
                                //   Navigator.of(context).pop();
                                // },
                                negativeTextStyle: const TextStyle(
                                    color: Color.fromARGB(255, 98, 71, 230)),
                                positiveText: "Continue ",
                                onPositiveClick: () {
                                  context.go("/verifyEmail");
                                });
                          },
                          animationType: DialogTransitionType.size,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(seconds: 1),
                        );
                      }
                    } on UserNotFoundAuthException {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return ClassicGeneralDialogWidget(
                            titleText: 'Oops!.',
                            contentText:
                                'You do not have an account, please register an account.',
                            // onPositiveClick: () {
                            //   Navigator.of(context).pop();
                            // },
                            negativeTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 98, 71, 230)),
                            onNegativeClick: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        animationType: DialogTransitionType.size,
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(seconds: 1),
                      );
                    } on WrongPasswordAuthException {
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return ClassicGeneralDialogWidget(
                            titleText: 'Oops!.',
                            contentText: 'The password you entered is wrong.',
                            negativeTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 98, 71, 230)),
                            onNegativeClick: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        animationType: DialogTransitionType.size,
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(seconds: 1),
                      );
                    } on GenericAuthException catch (e) {
                      devtools.log(e.runtimeType.toString());
                      showAnimatedDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return ClassicGeneralDialogWidget(
                            titleText: 'Authentication Error',
                            contentText:
                                "Please check your internet connectivity and try again.",
                            negativeTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 98, 71, 230)),
                            onNegativeClick: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        animationType: DialogTransitionType.size,
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(seconds: 1),
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    setState(() {
                      emailIsEmpty = validate.emailFieldIsEmpty();
                      emailIsValid = validate.emailIsValid();
                      passwordIsValid = validate.passwordIsValid();
                      passwordIsEmpty = validate.passwordFieldIsEmpty();
                      isLoading = false;
                    });
                  }
                },
                child: Center(
                  child: Container(
                    height: 60,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 98, 71, 230),
                    ),
                    child: Center(
                      child: isLoading
                          ? const SpinKitCircle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 50.0,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    context.go("/registration");
                  },
                  child: const Text(
                    "Register.",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color.fromARGB(255, 98, 71, 230)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
