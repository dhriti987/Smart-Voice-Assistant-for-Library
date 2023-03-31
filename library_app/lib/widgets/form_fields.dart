import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.text,
    required this.icon,
    required this.obscureText,
    this.textController,
    this.validator,
  }) : super(key: key);

  final String text;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController? textController;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: textController,
      obscureText: obscureText,
      decoration: InputDecoration(
          label: Text(text),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          prefixIcon: icon != null ? Icon(icon) : null),
    );
  }
}
