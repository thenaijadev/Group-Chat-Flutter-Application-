import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:notes/Screens/home.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import '../Screens/login_screen.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final userEmail = AuthService.firebase().currentUser?.email;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              devtools.log(user.toString());
              if (user.isEmailVerified) {
                devtools.log("u are verified");
                return const HomeScreen();
              } else {
                devtools.log("not verified");
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Image.asset("assets/images/sendmail.png"),
                        ),
                        const Center(
                          child: Text(
                            "Verify Your Email",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 40.0, horizontal: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 100, 100, 100),
                                    fontSize: 15),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text:
                                          'Please confirm that you want to use '),
                                  TextSpan(
                                      text: '$userEmail ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(
                                    text:
                                        'as your Notes account email address. Once it is dont you will be able to start creating and saving notes.as your Notes account email address.',
                                  )
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              AuthService.firebase().sendEmailVerification();
                              setState(() {
                                isLoading = false;
                              });
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return ClassicGeneralDialogWidget(
                                    titleText: 'Email Sent',
                                    contentText:
                                        'An email with a verification link has been sent to $userEmail',

                                    // onPositiveClick: () {
                                    //   Navigator.of(context).pop();
                                    // },
                                    positiveTextStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 98, 71, 230)),
                                    positiveText: "Continue ",
                                    onPositiveClick: () {
                                      Navigator.of(context).pop();

                                      context.go("/login");
                                      setState(() {});
                                    },
                                  );
                                },
                                animationType: DialogTransitionType.size,
                                curve: Curves.fastOutSlowIn,
                                duration: const Duration(seconds: 1),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 132, 107, 255),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: isLoading
                                    ? const SpinKitCircle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        size: 50.0,
                                      )
                                    : const Text(
                                        "Send Verification email.",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const VerifyEmailView()));
              }
            } else {
              return const Login();
            }

          default:
            return const Scaffold(
              body: Center(
                child: Text("loading"),
              ),
            );
        }
      }),
    );
  }
}
