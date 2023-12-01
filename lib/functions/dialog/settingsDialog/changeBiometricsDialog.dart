import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';
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
          hintText: 'Passwort',
          hintStyle: Theme.of(dialogContext).textTheme.labelSmall,
        ),
      ),
    ],
    onConfirm: () async {
      final String email = emailController.text;
      final String password = passwordController.text;

      try {

        Provider.of<MySettingsProvider>(context, listen: false).updateIsBiometricLock(switchState);

        MySecureStorageService mySecureStorageService = MySecureStorageService();
        mySecureStorageService.updateIsBiometricActive(switchState.toString());
        mySecureStorageService.updateUserInStorage(email, password);
      } on MyCustomException catch(e) {

        switch (e.keyword) {
          case "login-wrong":
            print(e.message);
            break;
          case "email-not-verified":
            print(e.message);
            break;
          case "not-logged-in":
            print(e.message);
            break;
        }
      } catch (e) {
        print(e.toString());
      }
    },
  );
}
