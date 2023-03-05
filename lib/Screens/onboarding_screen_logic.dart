import "package:flutter/material.dart";
import 'package:notes/Screens/home.dart';
import '../Helper/helper_function.dart';
import './onboarding_screen.dart';

class ScreenLogic extends StatefulWidget {
  const ScreenLogic({super.key});

  @override
  State<ScreenLogic> createState() => _ScreenLogicState();
}

class _ScreenLogicState extends State<ScreenLogic> {
  bool signedIn = false;
  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    if (await HelperFunctions.getUserLoggedInStatus() != null) {
      setState(() {
        signedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      return const HomeScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}
