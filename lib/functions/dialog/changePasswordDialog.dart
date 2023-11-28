import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';

void changePasswordDialog(BuildContext context, MyAccountSettingsService service) {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatNewPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Passwort ändern',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Altes Passwort',
                hintStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Neues Passwort',
                hintStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            TextField(
              controller: repeatNewPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Neues Passwort wiederholen',
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
              final String oldPassword = oldPasswordController.text;
              final String newPassword = newPasswordController.text;
              final String repeatNewPassword = repeatNewPasswordController.text;

              Navigator.of(dialogContext).pop();
              await service.updatePasswordFromCurrentUser(context, oldPassword, newPassword, repeatNewPassword);
            },
          ),
        ],
      );
    },
  );
}