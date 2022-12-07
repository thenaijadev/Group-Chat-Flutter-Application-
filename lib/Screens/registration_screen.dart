import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/Constants/routes.dart';
import "../Utilities/BiometricHelper.dart";
import '../Utilities/input_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../Components/google_register.dart';
import 'dart:developer' as devtools show log;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _confirmPasswordController;

  late final LocalAuthentication auth;
  late final bool canAuthenticateWithBiometrics;
  late final bool canAuthenticate;
  var Biometrics = BiometricHelper();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    // Biometrics.canAuthenticateWithBiometrics();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool showBiometrics = false;
  bool isAuthenticated = false;
  bool biometricsAvialable = false;
  bool isLoading = false;
  void isBiometricAvialble() async {
    biometricsAvialable =
        await BiometricHelper().canAuthenticateWithBiometrics();
    showBiometrics = await BiometricHelper().hasEnrolledBiometrics();

    setState(() {});
  }

  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool emailIsValid = true;
  bool emailIsEmpty = false;
  bool passwordIsValid = true;
  bool passwordsMatch = true;
  bool nameIsValid = false;
  bool passwordIsEmpty = false;
  bool nameIsEmpty = false;
  bool confirmPasswordIsEmpty = false;
  String text = "";
  bool isVisible = false;
  bool registrationSuccessfull = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Image.asset(
                  "assets/images/register.png",
                  height: 150,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: TextField(
                    onChanged: (value) {
                      if (value.length > 1) {
                        setState(() {
                          nameIsEmpty = false;
                        });
                      }
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Enter fullname: ",
                        errorText:
                            nameIsEmpty ? "This field is required" : null),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                              !isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 98, 71, 230),
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Enter Password",
                        errorText:
                            passwordIsValid ? null : "Password too short"),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: TextField(
                    onChanged: (value) {
                      if (value == password) {
                        setState(() {
                          passwordsMatch = true;
                        });
                      }
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: !isVisible,
                    controller: _confirmPasswordController,
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
                              !isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 98, 71, 230),
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Confirm Password",
                        errorText:
                            passwordsMatch ? null : "Passwords do not match."),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      void register() async {
                        setState(() {
                          isLoading = true;
                        });
                        email = _emailController.text;
                        password = _passwordController.text;
                        confirmPassword = _confirmPasswordController.text;
                        name = _nameController.text;
                        final validate = InputValidator(
                            fullName: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword);
                        final formisValid = validate.formIsValid();
                        if (formisValid) {
                          try {
                            final userCredentials = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            (userCredentials);
                            setState(() {
                              registrationSuccessfull = true;
                            });
                            if (registrationSuccessfull) {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return ClassicGeneralDialogWidget(
                                    titleText: 'Registration Successfull.',
                                    contentText:
                                        'Congratulations! You have successfully registered an account.',
                                    // onPositiveClick: () {
                                    //   Navigator.of(context).pop();
                                    // },
                                    negativeTextStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 98, 71, 230)),
                                    positiveText: "Continue ",
                                    onPositiveClick: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushNamed(
                                          context, VerifyEmailRoute);
                                    },
                                  );
                                },
                                animationType: DialogTransitionType.size,
                                curve: Curves.fastOutSlowIn,
                                duration: const Duration(seconds: 1),
                              );
                            }

                            // Navigator.pushNamed(context, "home");
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              registrationSuccessfull = false;
                            });

                            if (e.code == "email-already-in-use") {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return ClassicGeneralDialogWidget(
                                    titleText: 'Oops!.',
                                    contentText:
                                        'An account with this email already exists.',
                                    // onPositiveClick: () {
                                    //   Navigator.of(context).pop();
                                    // },
                                    negativeTextStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 98, 71, 230)),
                                    onNegativeClick: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                                animationType: DialogTransitionType.size,
                                curve: Curves.fastOutSlowIn,
                                duration: const Duration(seconds: 1),
                              );
                            } else {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return ClassicGeneralDialogWidget(
                                    titleText: 'Oops!.',
                                    contentText: e.code,
                                    // onPositiveClick: () {
                                    //   Navigator.of(context).pop();
                                    // },
                                    negativeTextStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 98, 71, 230)),
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
                          } catch (e) {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return ClassicGeneralDialogWidget(
                                  titleText: 'Oops!.',
                                  contentText: e.toString(),
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
                          }

                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            emailIsEmpty = validate.emailFieldIsEmpty();
                            emailIsValid = validate.emailIsValid();
                            passwordIsValid = validate.passwordIsValid();
                            passwordsMatch = validate.passwordsMatch();
                            nameIsEmpty = validate.fullNameIsEmpty();
                            passwordIsEmpty = validate.passwordFieldIsEmpty();
                            confirmPasswordIsEmpty =
                                validate.confirmPasswordIsEmpty();
                            isLoading = false;
                          });
                        }
                        Map details = {
                          "email": email,
                          "password": password,
                          "confirmPassword": confirmPassword,
                          "name": name
                        };
                        devtools.log(details.toString());
                      }

                      register();
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
                                  "Register",
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
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: GoogleRegisterButton()),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginRoute);
                      },
                      child: const Text(
                        "Login.",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color.fromARGB(255, 98, 71, 230)),
                      ),
                    )
                  ],
                ),
              ],
            )));
  }
}

void register() {}
