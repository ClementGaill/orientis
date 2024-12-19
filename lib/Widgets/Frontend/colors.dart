import 'package:flutter/material.dart';

const textColor = Colors.black;
const backgroundColor = Colors.white;
const primaryColor = Colors.black;
const primaryFgColor = Colors.black;
const secondaryColor = Color(0xFFf7f7f9);
const secondaryFgColor = Color.fromARGB(255, 194, 194, 195);
const accentColor = Color(0xFF5384fd);
const accentFgColor = Color.fromARGB(255, 61, 97, 189);
const greyColor = Color(0xFF9498a0);
const errorColor = Color.fromARGB(255, 251, 163, 163);
const warningColor = Color(0xFFe5a872);
  
const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: errorColor,
  onError: errorColor,
);
