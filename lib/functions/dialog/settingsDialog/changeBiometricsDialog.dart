import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
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
        style: Theme.of(context).textTheme.displayMedium,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'E-Mail*',
          hintStyle: Theme.of(dialogContext).textTheme.labelSmall,
        ),
      ),
      TextField(
        controller: passwordController,
        obscureText: true,
        style: Theme.of(context).textTheme.displayMedium,
        decoration: InputDecoration(
          hintText: 'Passwort*',
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
            MySnackBarService.showMySnackBar(context, "E-Mail oder Passwort ist falsch!");
            break;
          case "email-not-verified":
            MySnackBarService.showMySnackBar(context, "Die E-Mail wurde noch nicht verifiziert!");
            break;
          case "not-logged-in":
            MySnackBarService.showMySnackBar(context, "Sie sind nicht eingeloggt!");
            break;
        }

        return;
      } catch (e) {

        print(e.toString());
        return;
      }
    },
  );
}
