import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:notes/Helper/helper_function.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:notes/Services/Auth/firebase_auth_provider.dart';
import 'package:notes/Services/Database/database_service.dart';

createNewGroupDialog(BuildContext context) {
  bool isLoading = false;
  String groupName = "";
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create a group",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 98, 71, 230),
                      ),
                    )
                  : TextField(
                      onChanged: (value) {
                        groupName = value.toUpperCase();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Group Name",
                      ),
                    ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 172, 5, 5),
              ),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 52, 172, 5),
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final AuthUser? user = FirebaseAuthProvider().currentUser;
                final String? userName =
                    await HelperFunctions.getUserNameSharedPreferences();
                if (groupName.isNotEmpty) {
                  DatabaseService(uid: user?.uid)
                      .createGroup(userName!, user?.uid, groupName)
                      .whenComplete(() {
                    isLoading = false;
                    Navigator.of(context).pop(true);
                    showAnimatedDialog(
                        context: context,
                        builder: (context) {
                          return ClassicGeneralDialogWidget(
                            contentText: "Group successfully created ",
                          );
                        },
                        barrierDismissible: true,
                        duration: const Duration(milliseconds: 300));
                  });
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      });
    },
  ).then((value) => value ?? false);
}
