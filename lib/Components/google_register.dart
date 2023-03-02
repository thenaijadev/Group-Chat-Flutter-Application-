import "package:flutter/material.dart";
import '../Utilities/google_auth.dart';
import "package:flutter_animated_dialog/flutter_animated_dialog.dart";

class GoogleRegisterButton extends StatefulWidget {
  const GoogleRegisterButton({super.key});

  @override
  State<GoogleRegisterButton> createState() => _GoogleRegisterButtonState();
}

class _GoogleRegisterButtonState extends State<GoogleRegisterButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await GoogleAuth.googleSignIn(context);
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
                Navigator.popAndPushNamed(context, "/verifyEmail");
              },
            );
          },
          animationType: DialogTransitionType.size,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(seconds: 1),
        );
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
