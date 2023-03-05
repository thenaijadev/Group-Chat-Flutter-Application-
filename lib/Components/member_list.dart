import 'package:flutter/material.dart';

class MemberList extends StatefulWidget {
  const MemberList({
    super.key,
    this.members,
  });
  final Stream? members;

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  String getName(String fullString) {
    return fullString.substring(
        fullString.indexOf("_") + 1, fullString.indexOf("_") + 2);
  }

  String getUserName(String fullString) {
    return fullString.substring(
      fullString.indexOf("_") + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["members"] != null) {
            if (snapshot.data["members"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data["members"].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final String name = getName(snapshot.data["members"][index]);
                  final String userName =
                      getUserName(snapshot.data["members"][index]);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color.fromARGB(192, 98, 71, 230),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(userName),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("No members"),
              );
            }
          } else {
            return const Center(
              child: Text("No members"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(62, 98, 71, 230),
            ),
          );
        }
      },
    );
  }
}
