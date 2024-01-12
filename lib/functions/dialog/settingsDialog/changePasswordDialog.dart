import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';

void changePasswordDialog(BuildContext context) {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatNewPasswordController = TextEditingController();
  final MyAccountSettingsService service = MyAccountSettingsService();

  MyDialog.showCustomDialog(
    context: context,
    title: 'Passwort ändern',
    contentBuilder: (dialogContext) => [
      TextField(
      controller: oldPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Altes Passwort*',
          hintStyle: Theme.of(dialogContext).textTheme.labelMedium,
        ),
        style: Theme.of(dialogContext).textTheme.bodyMedium,
      ),
      TextField(
        controller: newPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Neues Passwort*',
          hintStyle: Theme.of(dialogContext).textTheme.labelMedium,
        ),
        style: Theme.of(dialogContext).textTheme.bodyMedium,
      ),
      TextField(
        controller: repeatNewPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Neues Passwort wiederholen*',
          hintStyle: Theme.of(dialogContext).textTheme.labelMedium,
        ),
        style: Theme.of(dialogContext).textTheme.bodyMedium,
      ),
    ],

    onConfirm: () async {
      final String oldPassword = oldPasswordController.text;
      final String newPassword = newPasswordController.text;
      final String repeatNewPassword = repeatNewPasswordController.text;

      await service.updatePasswordFromCurrentUser(context, oldPassword, newPassword, repeatNewPassword);
      },
  );
}