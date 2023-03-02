import "package:flutter/material.dart";

class GroupTile extends StatefulWidget {
  const GroupTile(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});
  final String? userName;
  final String? groupId;
  final String groupName;
  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 98, 71, 230),
          child: Text(
            widget.groupName.substring(0, 1).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          widget.groupName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Joint the conversation as ${widget.userName}",
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
