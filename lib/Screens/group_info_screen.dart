import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/Components/exit_group_dialog.dart';
import 'package:notes/Components/member_list.dart';
import 'package:notes/Services/Auth/firebase_auth_provider.dart';
import 'package:notes/Services/Database/database_service.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({
    super.key,
    required this.groupDetails,
  });
  final String? groupDetails;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  void initState() {
    getGroupMembers();
    super.initState();
  }

  @override
  String getId(String fullString) {
    return fullString.substring(
        fullString.indexOf(":") + 2, fullString.indexOf("_"));
  }

  String getGroupName(String fullString) {
    return fullString.substring(
        fullString.indexOf("_") + 1, fullString.indexOf("-"));
  }

  String getUserName(String fullString) {
    return fullString.substring(fullString.indexOf("-") + 1);
  }

  String getAdminString(String fullString) {
    return fullString.substring(fullString.indexOf("*") + 1);
  }

  String getAdmin(String fullString) {
    return fullString.substring(fullString.indexOf("_") + 1);
  }

  Stream? members;

  getGroupMembers() async {
    final String groupId = getId(widget.groupDetails!);
    DatabaseService(uid: FirebaseAuthProvider().currentUser?.uid)
        .getGroupMembers(groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? groupDetails = widget.groupDetails;
    String userName = getUserName(groupDetails!);
    String groupId = getId(groupDetails);
    String groupName = getGroupName(groupDetails);
    String adminString = getAdminString(groupDetails);
    String admin = getAdmin(adminString);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 71, 230),
        centerTitle: true,
        title: const Text("Group Information"),
        actions: [
          IconButton(
              onPressed: () {
                showExitDialog(context, () {
                  DatabaseService(uid: FirebaseAuthProvider().currentUser?.uid)
                      .toggleGroupJoin(groupId, userName, groupName)
                      .whenComplete(
                    () {
                      context.pop();
                      context.go("/home");
                    },
                  );
                });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(62, 98, 71, 230),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color.fromARGB(197, 98, 71, 230),
                    child: Text(
                      groupName.substring(1, 2).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: $groupName",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Admin: $admin",
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                ],
              ),
            ),
            MemberList(
              members: members,
            ),
          ],
        ),
      ),
    );
  }
}
