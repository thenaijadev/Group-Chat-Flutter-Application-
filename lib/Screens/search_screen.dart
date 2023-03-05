import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/Helper/helper_function.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:notes/Services/Auth/firebase_auth_provider.dart';
import 'package:notes/Services/Database/database_service.dart';
import 'dart:developer' as devtools show log;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    getcurrentUserIdAndName();
    super.initState();
  }

  AuthUser? user;

  getcurrentUserIdAndName() async {
    await HelperFunctions.getUserNameSharedPreferences().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuthProvider().currentUser;
  }

  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 98, 71, 230),
        title: const Text(
          "Search groups",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: const Color.fromARGB(255, 98, 71, 230),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      hintText: "Search groups:"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  initiateSearchMethod();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(65, 255, 255, 255),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              )
            ]),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(61, 1, 0, 2),
                  ),
                )
              : groupList(),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    final String searchText = _searchController.text.toUpperCase();

    try {
      if (searchText.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        await DatabaseService().searchByName(searchText).then((value) {
          setState(() {
            searchSnapshot = value;
            isLoading = false;
            hasUserSearched = true;
            devtools.log(searchText);
          });
        });
      }
    } catch (e) {
      devtools.log(e.toString());
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            itemCount: searchSnapshot?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return groupTile(
                  userName,
                  searchSnapshot?.docs[index]["groupId"],
                  searchSnapshot?.docs[index]["groupName"],
                  searchSnapshot?.docs[index]["admin"]);
            })
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Container(
                child: const Text(
                  "Search for a group to join",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
  }

  isGroupMember(
      String userName, String groupId, String groupName, String admin) async {
    final String? uid = FirebaseAuthProvider().currentUser?.uid;
    await DatabaseService(uid: uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
    String userName,
    String groupId,
    String groupName,
    String admin,
  ) {
    // Check if user exist in group
    isGroupMember(userName, groupId, groupName, admin);
    String getAdmin(String fullString) {
      return fullString.substring(
        fullString.indexOf("_") + 1,
      );
    }

    String groupAdmin = getAdmin(admin);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(103, 98, 71, 230),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: InkWell(
            onTap: () async {
              isLoading = true;
              await DatabaseService(uid: user?.uid)
                  .toggleGroupJoin(groupId, userName, groupName)
                  .then((value) {
                if (isJoined) {
                  setState(() {
                    isJoined = !isJoined;
                    isLoading = true;
                  });

                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text("Successfully left group."),
                      );
                    },
                  );
                  context.push("/home");
                } else {
                  setState(() {
                    isJoined = !isJoined;
                    isLoading = false;
                  });
                  context.push("/home");

                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text("Successfully joined group."),
                      );
                    },
                  );
                }
              });
            },
            child: isJoined
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 98, 71, 230),
                    ),
                    child: const Text("Joined",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 98, 71, 230),
                    ),
                    child: const Text("Join",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
        subtitle: Text("Admin: $groupAdmin"),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(186, 98, 71, 230),
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
