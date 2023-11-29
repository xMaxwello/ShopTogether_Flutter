import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';

void changeEmailDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final MyAccountSettingsService service = MyAccountSettingsService();

  MyDialog.showCustomDialog(
    context: context,
    title: 'E-Mail ändern',
    contentBuilder: (dialogContext) => [
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Neue E-Mail',
          hintStyle: Theme.of(dialogContext).textTheme.labelSmall,
        ),
      ),
      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Aktuelles Passwort',
          hintStyle: Theme.of(dialogContext).textTheme.labelSmall,
        ),
      ),
    ],
    onConfirm: () async {
      final String newEmail = emailController.text;
      final String password = passwordController.text;
      await service.updateEmailFromCurrentUser(context, newEmail, password);
    },
  );
}
