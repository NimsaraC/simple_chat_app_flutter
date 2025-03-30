// MessageContainer.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/message_model.dart';
import 'package:intl/intl.dart';

class MessageContainer extends StatelessWidget {
  final MessageModel message;
  const MessageContainer({super.key, required this.message});

  bool get isUser => FirebaseAuth.instance.currentUser?.uid == message.userId;

  String get formattedTime => DateFormat('hh:mm a').format(message.timestamp);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color.fromARGB(255, 167, 197, 240)
                  : const Color.fromARGB(255, 223, 223, 223),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(isUser ? 10 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 10),
              ),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 2,
              left: isUser ? 0 : 8,
              right: isUser ? 8 : 0,
            ),
            child: Text(
              formattedTime,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
