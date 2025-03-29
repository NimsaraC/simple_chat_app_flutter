import 'package:flutter/material.dart';
import 'package:simple_chat_app/pages/friends_screen.dart';
import 'package:simple_chat_app/pages/home_screen.dart';
import 'package:simple_chat_app/pages/profile_screen.dart';
import 'package:simple_chat_app/pages/user_search_screen.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    HomeScreen(),
    FriendsScreen(),
    UserSearchScreen(),
    ProfileScreen(),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    setItemOnTap(currentIndex);
    super.initState();
  }

  void setItemOnTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connect_without_contact),
            label: "Friends",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        selectedItemColor: secondaryColor,
        unselectedItemColor: gray,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        onTap: (value) {
          setItemOnTap(value);
        },
      ),
      body: pages[currentIndex],
    );
  }
}
