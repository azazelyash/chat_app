import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  /* --------------------------- Required Parameters -------------------------- */
  final String userName;
  final String groupId;
  final String groupName;

  const ChatPage(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.groupName),
      ),
    );
  }
}
