import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/Screens/login_screen.dart';
import 'Utilities/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
      // initialRoute: "/",
      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   "/": (context) => const OnBoarding(),

      //   '/registration': (context) => const RegistrationScreen(),
      //   "/login": (context) => const Login(),
      //   "/home": (context) => const HomeScreen(),
      // },
      home: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user!.emailVerified) {
                print("u are verivies");
              } else {
                print("not verified");
              }
              return const Login();
            default:
              return const Text("loading");
          }
        }),
      ),
    ),
  );
}
