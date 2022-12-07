import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/Constants/routes.dart';
import '../Components/popup.dart';

enum MenuAction { logout, settings }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

// actions are a list of widgets.
class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 98, 71, 230),
          title: const Text("NOTES"),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogOut = await showLogoutDialog(context);
                    if (shouldLogOut) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginRoute, (route) => false);
                    }
                    break;
                  case MenuAction.settings:
                    return;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("Logout"),
                  ),
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.settings,
                    child: Text("Account Settings"),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Center(
          child: Container(
            child: const Text("This is home"),
          ),
        ),
      ),
    );
  }
}
