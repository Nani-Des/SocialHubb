import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: const Color(0xFF581954),
        textTheme: GoogleFonts.quicksandTextTheme());
  }
}
