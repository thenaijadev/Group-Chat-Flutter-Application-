import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.groupDetails});
  final String? groupDetails;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String getId(String fullString) {
    return fullString.substring(0, fullString.indexOf("_"));
  }

  String getGroupName(String fullString) {
    return fullString.substring(
        fullString.indexOf("_") + 1, fullString.indexOf("-"));
  }

  String getUserName(String fullString) {
    return fullString.substring(fullString.indexOf("-") + 1);
  }

  @override
  Widget build(BuildContext context) {
    final String? groupDetails = widget.groupDetails;
    String userName = getUserName(groupDetails!);
    String groupId = getId(groupDetails);
    String groupName = getGroupName(groupDetails);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(groupName),
        backgroundColor: const Color.fromARGB(255, 98, 71, 230),
      ),
    );
  }
}
