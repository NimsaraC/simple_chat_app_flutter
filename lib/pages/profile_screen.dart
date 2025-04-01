import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/services/database/user_service.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  late UserModel user;
  final userService = UserService();
  String userId = "";
  bool isLoading = true;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  Future<void> getUserDetails() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      UserModel? useModel = await userService.getUserById(uid);
      if (useModel == null) {
        return;
      }
      setState(() {
        user = useModel;
        userId = uid;
        _usernameController.text = useModel.name;
      });
    } catch (e) {
      print("Error getting user details");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showUpdateDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Username'),
        content: TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Enter new username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: const TextStyle(
            color: gray,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: gray,
            ),
            onPressed: () {
              final newUser = UserModel(
                  id: user.id,
                  name: _usernameController.text,
                  email: user.email);
              userService.editUser(userId: userId, newUser: newUser);
              getUserDetails();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(fontSize: 20, color: gray),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileHeader(user: user),
                    const SizedBox(height: 20),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildAccountCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader({required UserModel user}) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: gray, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              "assets/splash.png",
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: gray,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                user.email,
                style: TextStyle(
                  color: gray,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: gray.withOpacity(0.3),
      thickness: 1,
    );
  }

  Widget _buildAccountCard() {
    return Card(
      color: primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: _showUpdateDialog,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                Icons.key,
                color: gray,
                size: 40,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: gray,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Update your account details",
                      style: TextStyle(
                        color: gray,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: gray,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
