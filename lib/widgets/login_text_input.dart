import 'package:flutter/material.dart';
import 'package:simple_chat_app/utils/constants/colors.dart';

class LoginTextInput extends StatelessWidget {
  final String hintText;
  final TextInputType? type;
  final String? Function(String?)? validator;
  final bool isObscure;
  final TextEditingController controller;
  const LoginTextInput({
    super.key,
    required this.hintText,
    this.type,
    this.validator,
    required this.isObscure,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: green.withOpacity(0.2),
          spreadRadius: 5,
          blurRadius: 7,
        )
      ]),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: type,
        validator: validator,
        style: TextStyle(
          color: gray,
          fontSize: 20,
        ),
        cursorColor: green,
        cursorErrorColor: Colors.red,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: primaryColor,
          hintStyle: TextStyle(
            color: secondaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: secondaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: secondaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: secondaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
