import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, this.title, this.lottie});
  final String? title;

  final String? lottie;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(lottie!),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
          child: Text(
            title!,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
