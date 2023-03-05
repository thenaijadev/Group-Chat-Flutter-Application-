import 'package:flutter/material.dart';
import '../Components/message_tile.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key, required this.userName, this.chats});
  final String? userName;
  final Stream? chats;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]["message"],
                        sender: snapshot.data.docs[index]["sender"],
                        sentByMe: widget.userName ==
                            snapshot.data.docs[index]["sender"]);
                  },
                )
              : Container(
                  child:
                      const Center(child: Text("Start sending messages....")),
                );
        });
  }
}
