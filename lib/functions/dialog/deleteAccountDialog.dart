import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';

void deleteAccountDialog(BuildContext context, MyAccountSettingsService service) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Account löschen?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text('Sind Sie sicher, dass Sie Ihren Account löschen möchten? Dies kann nicht rückgängig gemacht werden.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Abbrechen',
              style: GoogleFonts.tiltNeon(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Löschen', style: GoogleFonts.tiltNeon(
              textStyle: const TextStyle(color: Colors.red),
            ),
            ),
            onPressed: () async {
              service.deleteAccountFromCurrentUser(context);
            },
          ),
        ],
      );
    },
  );
}
