import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef DialogContentBuilder = List<Widget> Function(BuildContext context);
typedef DialogOnConfirm = Future<void> Function();

void showCustomDialog({
  required BuildContext context,
  required String title,
  required DialogContentBuilder contentBuilder,
  required DialogOnConfirm onConfirm,
  String confirmButtonText = 'Bestätigen',
  String cancelButtonText = 'Abbrechen',
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: contentBuilder(dialogContext),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              cancelButtonText,
              style: GoogleFonts.tiltNeon(),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text(
              confirmButtonText,
              style: GoogleFonts.tiltNeon(),
            ),
            onPressed: () async {
              await onConfirm();
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}