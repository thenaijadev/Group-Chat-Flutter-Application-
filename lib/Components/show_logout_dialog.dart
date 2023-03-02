import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Services/Auth/firebase_auth_provider.dart';
import '../Helper/helper_function.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(
          Icons.logout_outlined,
          color: Colors.red,
          size: 50,
        ),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 52, 172, 5),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 172, 5, 5),
            ),
            onPressed: () async {
              await FirebaseAuthProvider().logOut();
              Navigator.of(context).pop(true);
              context.go("/login");
              HelperFunctions.saveUserEmailSharedPreferences("");
              HelperFunctions.setUSerLoggedInStatus(false);
              HelperFunctions.saveUserNameSharedPreferences("");
            },
            child: const Text("Log Out"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
