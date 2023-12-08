import 'package:flutter/material.dart';

typedef DialogContentBuilder = List<Widget> Function(BuildContext context);
typedef DialogOnConfirm = Future<void> Function();

class MyDialog {
  static void showCustomDialog({
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: contentBuilder(dialogContext),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                cancelButtonText,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
              ),
              onPressed: () async {
                await onConfirm();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                confirmButtonText,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}