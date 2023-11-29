import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';

void deleteAccountDialog(BuildContext context) {
  final TextEditingController passwordController = TextEditingController();
  final MyAccountSettingsService service = MyAccountSettingsService();

  MyDialog.showCustomDialog(
    context: context,
    title: 'Account löschen',
    contentBuilder: (dialogContext) => [
      Text('Sind Sie sicher, dass Sie Ihren Account löschen möchten? Dies kann nicht rückgängig gemacht werden.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Passwort',
          hintStyle: Theme.of(dialogContext).textTheme.labelSmall,
        ),
      ),
    ],

    onConfirm: () async {
      final String password = passwordController.text;

      service.deleteAccountFromCurrentUser(context, password);
    },
  );
}
