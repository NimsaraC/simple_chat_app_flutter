// ChatScreen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/chat_model.dart';
import 'package:simple_chat_app/models/message_model.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/services/database/message_service.dart';
import 'package:simple_chat_app/services/database/user_service.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';
import 'package:simple_chat_app/widgets/message_container.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel chat;
  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final messageService = MessageService();
  ScrollController _scrollController = ScrollController();
  String username = "";

  @override
  void initState() {
    super.initState();
    getSecondUser();
    _scrollController = ScrollController();
  }

  Future<void> getSecondUser() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String targetUserId = widget.chat.UserOneId == currentUserId
        ? widget.chat.UserTwoId
        : widget.chat.UserOneId;

    UserModel? user = await UserService().getUserById(targetUserId);
    setState(() => username = user!.name);
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteDialog(MessageModel message) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: primaryColor,
        title: const Text(
          'Delete message',
          style: TextStyle(
            color: gray,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this message? This action cannot be undone.',
          style: TextStyle(
            color: gray,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: gray,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await messageService.deleteMessage(
                  messageId: message.id, chatId: message.chatId);
              Navigator.pop(context);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat deleted successfully'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    try {
      await messageService.sendMessage(
        chatId: widget.chat.id,
        content: messageController.text.trim(),
      );
      messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: gray),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("assets/splash.png"),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: gray,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: width,
        height: height,
        color: primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: messageService.getMessageList(widget.chat.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                color: gray, size: 50),
                            SizedBox(height: 16),
                            Text("No messages yet",
                                style: TextStyle(color: gray, fontSize: 18)),
                            SizedBox(height: 8),
                            Text("Start the conversation!",
                                style: TextStyle(
                                    color: gray.withOpacity(0.7),
                                    fontSize: 14)),
                          ],
                        ),
                      );
                    }

                    final messages = snapshot.data!;
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true, // Show newest messages at bottom
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onLongPress: () =>
                                _showDeleteDialog(messages[index]),
                            child: MessageContainer(message: messages[index]));
                      },
                    );
                  },
                ),
              ),
              Container(
                color: secondaryColor,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        style: TextStyle(color: gray, fontSize: 17),
                        decoration: InputDecoration(
                          hintText: "Type Your Message",
                          hintStyle:
                              TextStyle(color: secondaryColor, fontSize: 17),
                          filled: true,
                          fillColor: Color.fromARGB(255, 218, 218, 218),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        onFieldSubmitted: (_) => sendMessage(),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: sendMessage,
                      icon: Icon(Icons.send, color: primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
