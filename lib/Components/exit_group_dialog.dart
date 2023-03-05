import 'package:flutter/material.dart';

Future<bool> showExitDialog(BuildContext context, onPressed) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(
          Icons.exit_to_app,
          color: Colors.red,
          size: 50,
        ),
        content: const Text("Are you sure you want to exit the group?"),
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
            onPressed: onPressed,
            child: const Text("Leave"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
