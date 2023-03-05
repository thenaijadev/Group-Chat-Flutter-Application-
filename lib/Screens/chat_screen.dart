import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes/Services/Database/database_service.dart';
import 'dart:developer' as devtools show log;
import '../Components/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.groupDetails});
  final String? groupDetails;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String getId(String fullString) {
    return fullString.substring(1, fullString.indexOf("_"));
  }

  String getGroupName(String fullString) {
    return fullString.substring(
        fullString.indexOf("_") + 1, fullString.indexOf("-"));
  }

  String getUserName(String fullString) {
    return fullString.substring(
        fullString.indexOf("-") + 1, fullString.indexOf("*"));
  }

  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    final String? groupDetails = widget.groupDetails;
    String groupId = getId(groupDetails!);

    DatabaseService().getChats(groupId).then((value) {
      chats = value;
    });

    DatabaseService().getGroupAdmin(groupId).then((value) {
      devtools.log(groupId);
      setState(() {
        admin = value;
        devtools.log(admin);
      });
    });
  }

  TextEditingController messageController = TextEditingController();
  String? userName;
  String? groupId;
  @override
  Widget build(BuildContext context) {
    String? groupDetails = "${widget.groupDetails}*$admin";
    userName = getUserName(groupDetails);
    groupId = getId(groupDetails);
    String groupName = getGroupName(groupDetails);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(groupName),
        backgroundColor: const Color.fromARGB(255, 98, 71, 230),
        actions: [
          IconButton(
            onPressed: () {
              context.push(
                  "/home/chat:${widget.groupDetails}/groupInfo:$groupDetails");
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Stack(
        children: [
          ChatMessages(
            userName: userName,
            chats: chats,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(
                          color: Colors.black,
                          backgroundColor: Colors.white,
                          decorationColor: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 98, 71, 230),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessagesMap = {
        "sender": userName,
        "time": DateTime.now().microsecondsSinceEpoch,
        "message": messageController.text
      };
      await DatabaseService().sendMessage(groupId, chatMessagesMap);

      messageController.clear();
    }
  }
}
