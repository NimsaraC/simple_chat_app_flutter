// ChatScreen.dart
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/chat_model.dart';
import 'package:simple_chat_app/models/message_model.dart';
import 'package:simple_chat_app/services/database/message_service.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                "Username",
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
                        return MessageContainer(message: messages[index]);
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
