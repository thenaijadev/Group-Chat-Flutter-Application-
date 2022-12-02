import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:notes/Screens/login_screen.dart';
import 'package:notes/Screens/verify_email.dart';
import 'Utilities/firebase_options.dart';
import 'Screens/onboarding_screen.dart';
import 'Screens/home.dart';
import 'Screens/registration_screen.dart';

import 'Constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusColor: const Color.fromARGB(255, 98, 71, 230),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 3,
              color: Color.fromARGB(255, 214, 206, 255),
            ),
          ),
        ),
      ),
      initialRoute: "/",
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        "/": (context) => const OnBoarding(),
        RegisterRoute: (context) => const RegistrationScreen(),
        LoginRoute: (context) => const Login(),
        HomeRoute: (context) => const HomeScreen(),
        VerifyEmailRoute: (context) => const VerifyEmailView()
      },
    ),
  );
}
