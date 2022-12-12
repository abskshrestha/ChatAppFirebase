import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String userName;

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: Center(
        child: Text(widget.groupName),
      ),
    );
  }
}


//git commads

// git add .

// git commit -m "message"

// git push -u origin main