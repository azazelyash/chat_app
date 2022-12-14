import 'package:chat_application/pages/chat_page.dart';
import 'package:chat_application/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  /* --------------------------- Required Parameters -------------------------- */

  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile(
      {super.key,
      required this.groupName,
      required this.groupId,
      required this.userName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 30,
            child: const Icon(
              Icons.group,
              color: Colors.white,
            ),
          ),
          title: Text(
            widget.groupName.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Join in as ${widget.userName}',
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
