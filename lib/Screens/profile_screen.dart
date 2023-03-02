import 'package:flutter/material.dart';
import 'package:notes/Components/profile_drawer.dart';
import '../Helper/helper_function.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName = "";
  String? email = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    email = await HelperFunctions.getUserEmailSharedPreferences();
    userName = await HelperFunctions.getUserNameSharedPreferences();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: ProfileDrawer(
          email: email,
          userName: userName,
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 98, 71, 230),
          title: const Text("Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(
                  Icons.account_circle,
                  size: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Full name: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Email Address: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
