import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/services/database/user_service.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';
import 'package:simple_chat_app/widgets/login_text_input.dart';
import 'package:simple_chat_app/widgets/user_card.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  List<String> friends = [];
  late UserModel currentUser;
  bool isLoading = true;
  final userService = UserService();
  final usernameController = TextEditingController();

  Future<void> getAllUsers() async {
    try {
      List<UserModel> users = await userService.getAllUsers();
      setState(() {
        allUsers = users;
        filteredUsers = [];
      });
    } catch (e) {
      print("Error getting users");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
    getAllUsers();
  }

  Future<void> getCurrentUserDetails() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      UserModel user = await userService.getUserById(userId) as UserModel;
      setState(() {
        currentUser = user;
        friends = currentUser.friends;
      });
    } catch (e) {
      print("Error getting current user");
    }
  }

  Future<void> addFriend(String userId) async {
    try {
      if (userId == currentUser.id) {
        return;
      }
      if (friends.contains(userId)) {
        return;
      } else {
        setState(() {
          friends.add(userId);
        });
      }
      currentUser.friends = friends;
      await userService.addFriend(friendId: userId, isAdd: true);
      setState(() {});
    } catch (e) {
      print("Error adding user");
    }
  }

  Future<void> removeFriend(String userId) async {
    try {
      if (userId == currentUser.id) {
        return;
      }
      if (!friends.contains(userId)) {
        return;
      } else {
        setState(() {
          friends.remove(userId);
        });
      }
      currentUser.friends = friends;
      await userService.addFriend(friendId: userId, isAdd: false);
      setState(() {});
    } catch (e) {
      print("Error remove friend");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: primaryColor,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
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
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.search,
                          color: gray,
                          size: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: filteredUsers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final UserModel user = filteredUsers[index];
                          return userCard(
                            friendList: false,
                            isFriend: friends.contains(user.id) ? true : false,
                            user: user,
                            onTap: () => friends.contains(user.id)
                                ? removeFriend(user.id)
                                : addFriend(user.id),
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
}
