import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/pages/login_screen.dart';
import 'package:simple_chat_app/pages/main_screen.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogged = false;

  void isLoggedIn() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          isLogged = true;
        });
      } else {
        setState(() {
          isLogged = false;
        });
      }
    } catch (e) {
      print("Error check user");
    }
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  void checkUser() {
    if (isLogged) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return MainScreen();
        },
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          color: primaryColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        "Simple Chat",
                        style: TextStyle(
                          color: gray,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Connect. Chat. Anytime, Anywhere",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: width,
                  height: width,
                  child: Image.asset("assets/splash.png"),
                ),
                Container(
                  height: 100,
                  width: width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(204, 251, 250, 255),
                        Color.fromARGB(199, 251, 250, 255),
                        Color.fromARGB(241, 251, 250, 255),
                        Color.fromARGB(241, 251, 250, 255),
                      ],
                      stops: [0, 0, 0.7, 1.0],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => checkUser(),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 70,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 196, 226, 235)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: width,
                    color: const Color.fromARGB(241, 251, 250, 255),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
