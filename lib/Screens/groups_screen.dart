import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/Components/create_new_group_dialog.dart';
import 'package:notes/Components/group_list.dart';
import 'package:notes/Components/home_drawer.dart';
import 'package:notes/Helper/helper_function.dart';
import 'package:notes/Services/Auth/firebase_auth_provider.dart';
import 'package:notes/Services/Database/database_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

// actions are a list of widgets.
class _NotesViewState extends State<NotesView> {
  String? userName = "";
  String? email = "";
  Stream? groups;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    email = await HelperFunctions.getUserEmailSharedPreferences();
    userName = await HelperFunctions.getUserNameSharedPreferences();
    setState(() {});
    await DatabaseService(uid: FirebaseAuthProvider().currentUser?.uid)
        .getUserGroups()
        .then((snapshots) {
      groups = snapshots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 98, 71, 230),
          title: const Text("Groups"),
          actions: [
            IconButton(
              onPressed: () {
                context.go("/search");
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        drawer: HomeDrawer(
          email: email,
          userName: userName,
        ),
        body: groupList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 98, 71, 230),
          child: const Icon(Icons.add),
          onPressed: () {
            createNewGroupDialog(context);
          },
        ),
      ),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["groups"] != null) {
            if (snapshot.data["groups"].length != 0) {
              return GroupList(snapshot: snapshot);
            } else {
              noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
          return noGroupWidget();
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 98, 71, 230),
            ),
          );
        }
      },
    );
  }

  Widget noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                createNewGroupDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "You have not joined any group. Please click on the '+' button or search for existing groups to join.",
              textAlign: TextAlign.center,
            )
          ]),
    );
  }
}
