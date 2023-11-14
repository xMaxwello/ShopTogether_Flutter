import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySnackBarService {

  static void defaultActionFunc() {}

  static void showMySnackBar(BuildContext context, String showText, {bool isError = true, bool isFunctionAvailable = false, Function() actionFunction = defaultActionFunc, actionLabel = 'Bestätigen'}) {

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            showText,
            style: GoogleFonts.tiltNeon(
                fontSize: 16
            ),
          ),
          backgroundColor: isError ? Theme.of(context).colorScheme.error: Theme.of(context).snackBarTheme.backgroundColor,
          action: isFunctionAvailable == false ? null : SnackBarAction(
            label: actionLabel,
            onPressed: actionFunction,
            textColor: Theme.of(context).snackBarTheme.actionTextColor,
          ),
        ));
  }
}