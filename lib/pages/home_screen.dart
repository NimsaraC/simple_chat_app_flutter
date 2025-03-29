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
      List<ChatModel> userChats = await ChatService()
          .getUserChats(userId: FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        chats = userChats;
        filteredChats = chats;
      });
    } catch (e) {
      print("Error getting chats $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserChats();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: green,
        child: Icon(
          Icons.add,
          color: gray,
          size: 40,
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: gray,
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                width: width,
                height: height,
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
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: gray,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: gray,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: filteredChats.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final chat = filteredChats[index];
                          return ChatCard(chatModel: chat);
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
