import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';
import 'package:shopping_app/functions/services/storage/MySecureStorageService.dart';

void changeBiometricsDialog(BuildContext context, bool switchState) {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  MyDialog.showCustomDialog(
    context: context,
    title: 'Biometrischen Login aktivieren',
    contentBuilder: (dialogContext) => [
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'E-Mail',
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
      final String email = emailController.text;
      final String password = passwordController.text;

      MySettingsProvider mySettingsProvider = MySettingsProvider();
      mySettingsProvider.updateIsBiometricLock(switchState);

      MySecureStorageService mySecureStorageService = MySecureStorageService();
      mySecureStorageService.updateIsBiometricActive(switchState.toString());
      mySecureStorageService.updateUserInStorage(email, password);
    },
  );
}
