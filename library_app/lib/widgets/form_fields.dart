import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: validator,
        controller: textController,
        obscureText: obscureText,
        decoration: InputDecoration(
            label: Text(text),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: icon != null ? Icon(icon) : null),
      ),
    );
  }
}

class MyDateField extends StatefulWidget {
  const MyDateField({
    Key? key,
    required this.text,
    required this.icon,
    required this.obscureText,
    required this.textController,
    this.validator,
  }) : super(key: key);

  final String text;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController textController;
  final String? Function(String? value)? validator;

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.textController,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          label: Text(widget.text),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30),
          ),
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        ),
        readOnly: true,
        onTap: () async {
          DateTime today = DateTime.now();
          DateTime? pickDate = await showDatePicker(
            context: context,
            initialDate: today,
            firstDate: today,
            lastDate: DateTime(today.year + 1),
          );

          if (pickDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(pickDate);
            setState(() {
              widget.textController.text = formattedDate;
            });
          }
        },
      ),
    );
  }
}
