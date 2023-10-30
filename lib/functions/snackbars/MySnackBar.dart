import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySnackBar {

  static void showMySnackBar(BuildContext context, String showText, {Color backgroundColor = Colors.red, Color foregroundColor = Colors.white}) {

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            showText,
            style: GoogleFonts.tiltNeon(
                fontSize: 18
            ),
          ),
          backgroundColor: backgroundColor,
        ));
  }
}