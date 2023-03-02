import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/Router/routes.dart';
import 'Services/Auth/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 98, 71, 230),
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
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
        routerConfig: MyRouter.router);
  }
}
