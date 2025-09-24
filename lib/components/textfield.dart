import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isNum;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.isNum,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE7E7E7), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE7E7E7), width: 2),
        ),
        fillColor: Color(0xFF292929),
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFFE7E7E7)),
      ),
    );
  }
}
