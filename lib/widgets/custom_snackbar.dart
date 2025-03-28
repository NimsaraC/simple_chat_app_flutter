import 'package:flutter/material.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
  required bool? isError,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: primaryColor),
      ),
      backgroundColor:
          isError! ? Colors.red : const Color.fromARGB(255, 24, 62, 116),
      duration: const Duration(seconds: 2),
    ),
  );
}
