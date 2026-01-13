import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String text;
  final TextEditingController? control;
  final bool isObscure;

  const CustomTextfield({
    super.key,
    required this.text,
    required this.control,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      controller: control,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
