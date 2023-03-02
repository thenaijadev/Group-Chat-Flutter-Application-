import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/Components/group_tile.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key, required this.snapshot});
  final AsyncSnapshot snapshot;
  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  String getId(String fullString) {
    return fullString.substring(0, fullString.indexOf("_"));
  }

  String getName(String fullString) {
    return fullString.substring(fullString.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.snapshot.data["groups"].length,
        itemBuilder: (context, index) {
          int reverseIndex = widget.snapshot.data["groups"].length - index - 1;
          String userName = widget.snapshot.data["fullName"];
          String groupId = getId(widget.snapshot.data["groups"][reverseIndex]);
          String groupName =
              getName(widget.snapshot.data["groups"][reverseIndex]);

          return GestureDetector(
            onTap: () {
              context.go("/home/chat:${groupId}_$groupName-$userName");
            },
            child: GroupTile(
                userName: userName, groupId: groupId, groupName: groupName),
          );
        });
  }
}
