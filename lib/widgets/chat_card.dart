import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/chat_model.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/pages/chat_screen.dart';
import 'package:simple_chat_app/services/database/user_service.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';

class ChatCard extends StatefulWidget {
  final ChatModel chatModel;
  const ChatCard({super.key, required this.chatModel});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  late ChatModel chat;
  late UserModel chatUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    chat = widget.chatModel;
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    try {
      String userOne = chat.UserOneId;
      String userTwo = chat.UserTwoId;
      String currentUser = FirebaseAuth.instance.currentUser!.uid;
      String chatUserId = currentUser == userOne ? userTwo : userOne;
      UserModel? user = await UserService().getUserById(chatUserId);
      setState(() {
        chatUser = user!;
      });
    } catch (e) {
      print("Error getting chat userDetails: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox()
        : Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: primaryColor,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chat: chat),
                ),
              ),
              // onLongPress: _showDeleteDialog,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/splash.png",
                        height: 69,
                        width: 69,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatUser.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: gray,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.chatModel.lastMessage,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: gray.withOpacity(0.6),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          "5min",
                          style: TextStyle(
                            color: gray.withOpacity(0.5),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
