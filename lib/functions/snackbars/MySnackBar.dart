import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySnackBar {

  static void defaultActionFunc() {

  }

  static void showMySnackBar(BuildContext context, String showText, {Color backgroundColor = Colors.red, Color foregroundColor = Colors.white, bool isFunctionAvailable = false, Function() actionFunction = defaultActionFunc, actionLabel = 'Bestätigen', actionColor = Colors.white}) {

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            showText,
            style: GoogleFonts.tiltNeon(
                fontSize: 16
            ),
          ),
          backgroundColor: backgroundColor,
          action: isFunctionAvailable == false ? null : SnackBarAction(
            label: actionLabel,
            onPressed: actionFunction,
            textColor: actionColor,
          ),
        ));
  }
}