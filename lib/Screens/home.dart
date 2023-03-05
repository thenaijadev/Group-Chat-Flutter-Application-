import 'package:flutter/material.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import '../Screens/verify_email.dart';
import 'groups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    if (user != null) {
      if (user.isEmailVerified) {
        return const GroupsScreen();
      } else {
        return const VerifyEmailView();
      }
    }
    return const VerifyEmailView();
  }
}
