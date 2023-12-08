import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';

void changeUserNameDialog(BuildContext context) {
  final TextEditingController newPrenameController = TextEditingController();
  final TextEditingController newSurnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final MyAccountSettingsService service = MyAccountSettingsService();

  MyDialog.showCustomDialog(
    context: context,
    title: 'Name ändern',
    contentBuilder: (dialogContext) => [
      TextField(
        controller: newPrenameController,
        decoration: InputDecoration(
          hintText: 'Vorname',
          hintStyle: Theme.of(dialogContext).textTheme.labelMedium,
        ),
        style: Theme.of(dialogContext).textTheme.bodyMedium,
      ),
      TextField(
        controller: newSurnameController,
        decoration: InputDecoration(
          hintText: 'Nachname',
          hintStyle: Theme.of(dialogContext).textTheme.labelMedium,
        ),
        style: Theme.of(dialogContext).textTheme.bodyMedium,
      ),
      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Passwort',
          hintStyle: Theme.of(dialogContext).textTheme.labelMedium,
        ),
        style: Theme.of(dialogContext).textTheme.bodyMedium,
      ),
    ],
    onConfirm: () async {
      final String newPrename = newPrenameController.text;
      final String newSurname = newSurnameController.text;
      final String password = passwordController.text;

      await service.updateNameFromCurrentUser(context, newPrename, newSurname, password);
    },
  );
}
