// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:orienty/Widgets/Frontend/colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? icon;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({super.key, 
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.onSubmitted,
    this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: secondaryColor,
      ),
    );
  }
}
