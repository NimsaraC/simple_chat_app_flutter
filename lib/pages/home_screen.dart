import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/chat_model.dart';
import 'package:simple_chat_app/services/database/chat_service.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';
import 'package:simple_chat_app/widgets/chat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatModel> chats = [];
  List<ChatModel> filteredChats = [];
  bool isLoading = true;

  Future<void> getUserChats() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      List<ChatModel> userChats =
          await ChatService().getUserChats(userId: userId);
      if (mounted) {
        setState(() {
          chats = userChats;
          filteredChats = chats;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error getting chats: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading chats: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserChats();
  }

  Future<void> _showDeleteDialog(String chatId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: primaryColor,
        title: const Text(
          'Delete Chat',
          style: TextStyle(
            color: gray,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this chat? This action cannot be undone.',
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
              try {
                await ChatService().deleteChat(chatId);
                await getUserChats();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat deleted successfully'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting chat: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: gray,
                ),
              )
            : Container(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                width: size.width,
                height: size.height,
                color: primaryColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Simple Chat",
                          style: TextStyle(
                            color: gray,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: gray,
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: filteredChats.isEmpty
                          ? Center(
                              child: Text(
                                "No chats available",
                                style: TextStyle(
                                  color: gray,
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredChats.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final chat = filteredChats[index];
                                return GestureDetector(
                                  onLongPress: () => _showDeleteDialog(chat.id),
                                  child: ChatCard(chatModel: chat),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
