import 'package:flutter/material.dart';

import '../utils/color_config.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final int? maxLines;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  const CustomTextField(
      {super.key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      required this.labelText,
      required this.hintText,
      this.maxLines,
      this.obscureText = false,
      this.suffixIcon,
      this.onChanged,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      validator: validator,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: ColorConfig.primaryColor, width: 2)),
          focusedBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: ColorConfig.primaryColor, width: 2)),
          hintStyle: const TextStyle(
              height: 2.5,
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 20)),
    );
  }
}
