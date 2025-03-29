import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/chat_model.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/pages/chat_screen.dart';
import 'package:simple_chat_app/services/database/chat_service.dart';
import 'package:simple_chat_app/services/database/user_service.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';
import 'package:simple_chat_app/widgets/login_text_input.dart';
import 'package:simple_chat_app/widgets/user_card.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  bool isLoading = true;
  final userService = UserService();
  final usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    try {
      List<UserModel> users = await userService.getUserFriends();
      setState(() {
        allUsers = users;
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      print("Error getting users: \$e");
      setState(() => isLoading = false);
    }
  }

  void searchUsers(String query) {
    setState(() {
      filteredUsers = allUsers
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    });
  }

  Future<void> returnChatScreen(String userTwo) async {
    try {
      String userOne = FirebaseAuth.instance.currentUser!.uid;
      ChatModel chatModel = await ChatService()
          .getChatByUsers(userOne: userOne, userTwo: userTwo);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatScreen(chat: chatModel),
        ),
      );
    } catch (e) {
      print("Error getting chat $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          color: primaryColor,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LoginTextInput(
                            hintText: "Search Username",
                            isObscure: false,
                            controller: usernameController,
                            onChanged: searchUsers,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.search, color: Colors.grey, size: 30),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return userCard(
                              friendList: true,
                              isFriend: true,
                              user: user,
                              onTap: () => returnChatScreen(user.id));
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
