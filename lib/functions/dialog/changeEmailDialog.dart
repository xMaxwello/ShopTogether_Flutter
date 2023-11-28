import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';


void changeEmailDialog(BuildContext context, MyAccountSettingsService service) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('E-Mail ändern',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Neue E-Mail',
                hintStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Aktuelles Passwort',
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
              final String newEmail = emailController.text;
              final String password = passwordController.text;

              Navigator.of(dialogContext).pop();
              await service.updateEmailFromCurrentUser(context, newEmail, password);
            },
          ),
        ],
      );
    },
  );
}