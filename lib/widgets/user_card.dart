import 'package:flutter/material.dart';
import 'package:simple_chat_app/models/user_model.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';

Widget userCard({
  required bool isFriend,
  required bool friendList,
  required UserModel user,
  required Function() onTap,
}) {
  return Column(
    children: [
      ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              "assets/splash.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          user.name,
          style: TextStyle(
            color: gray,
          ),
        ),
        trailing: IconButton(
          onPressed: onTap,
          icon: Icon(
            isFriend && !friendList
                ? Icons.person_remove
                : !isFriend && !friendList
                    ? Icons.person_add
                    : Icons.message,
            color: gray,
          ),
        ),
        tileColor: primaryColor,
      ),
      Divider(
        color: gray,
      )
    ],
  );
}

