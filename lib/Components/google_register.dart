import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'dart:developer' as devtools show log;

class GoogleRegisterButton extends StatefulWidget {
  const GoogleRegisterButton({super.key});

  @override
  State<GoogleRegisterButton> createState() => _GoogleRegisterButtonState();
}

class _GoogleRegisterButtonState extends State<GoogleRegisterButton> {
  bool isLoading = false;

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();

    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
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
                negativeTextStyle:
                    const TextStyle(color: Color.fromARGB(255, 98, 71, 230)),
                positiveText: "Continue ",
                onPositiveClick: () {
                  Navigator.pushNamed(context, "/verifyEmail");
                },
              );
            },
            animationType: DialogTransitionType.size,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(seconds: 1),
          );
        } on FirebaseAuthException catch (e) {
          devtools.log("This is error: $e.");
          devtools.log(e.message.toString());
        } catch (e) {
          devtools.log(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _googleSignIn(context);
      },
      child: Center(
        child: Container(
          height: 60,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 2, color: const Color.fromARGB(255, 98, 71, 230)),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/google.png",
                  height: 40,
                ),
                const Text(
                  "Register with Google",
                  style: TextStyle(
                      color: Color.fromARGB(255, 98, 71, 230),
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
