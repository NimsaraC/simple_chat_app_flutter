import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/chat_model.dart';
import 'package:simple_chat_app/models/user_model.dart';
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
      String currentUSer = FirebaseAuth.instance.currentUser!.uid;
      String chatUSerId = "";
      currentUSer == userOne ? chatUSerId = userTwo : chatUSerId = userOne;
      UserModel? user = await UserService().getUserById(chatUSerId);
      setState(() {
        chatUser = user!;
      });
    } catch (e) {
      print("Error getting chat userDetails");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox()
        : Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5, color: Colors.grey, offset: Offset(5, 5))
                ]),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 69,
                    width: 69,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        100,
                      ),
                      child: Image.asset(
                        "assets/splash.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatUser.name,
                          maxLines: 1,
                          style: TextStyle(
                            color: gray,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          widget.chatModel.lastMessage,
                          style: TextStyle(
                            color: gray.withOpacity(0.6),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "5min",
                        style: TextStyle(
                          color: gray.withOpacity(0.5),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   width: 35,
                      //   height: 35,
                      //   decoration: BoxDecoration(
                      //       color: const Color.fromARGB(255, 55, 174, 230),
                      //       borderRadius: BorderRadius.circular(10)),
                      //   child: Center(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(10),
                      //       child: Text(
                      //         "1",
                      //         style: TextStyle(
                      //           color: primaryColor,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
