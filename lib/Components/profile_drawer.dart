import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Helper/helper_function.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key, this.userName, this.email});
  final String? userName;
  final String? email;
  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(30),
        children: <Widget>[
          const Icon(Icons.account_circle, size: 150, color: Colors.grey),
          SizedBox(
            height: 20,
            child: Text(
              widget.userName!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20,
            child: Text(
              widget.email!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: const Text(
              "Groups",
              style: TextStyle(),
            ),
            onTap: () {
              context.go("/");
            },
            leading: const Icon(
              Icons.group,
            ),
          ),
          ListTile(
            onTap: () {
              context.go("/home/profile");
            },
            selected: true,
            title: const Text("Profile"),
            leading: const Icon(
              Icons.group,
            ),
          ),
          ListTile(
            onTap: () async {
              HelperFunctions.logout(context);
            },
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
