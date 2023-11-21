import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';

void changeUserNameDialog(BuildContext context, MyAccountSettingsService service) {
  final TextEditingController newPrenameController = TextEditingController();
  final TextEditingController newSurnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Name ändern',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPrenameController,
              decoration: InputDecoration(
                hintText: 'Vorname',
                hintStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            TextField(
              controller: newSurnameController,
              decoration: InputDecoration(
                hintText: 'Nachname',
                hintStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Passwort eingeben',
                hintStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Abbrechen',
              style: GoogleFonts.tiltNeon(),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text('Ändern',
              style: GoogleFonts.tiltNeon(),
            ),
            onPressed: () async {
              final String newPrename = newPrenameController.text;
              final String newSurname = newSurnameController.text;
              final String password = passwordController.text;

              Navigator.of(dialogContext).pop();
              await service.updateNameFromCurrentUser(context, newPrename, newSurname, password);
            },
          ),
        ],
      );
    },
  );
}