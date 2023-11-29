import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';


///TODO: MyAccountSettingsService könntest du auch einfach in der Funktion deklarieren und dann aufrufen,
///dann musst du hier nichts übergeben => bei den anderen Dialogs auch. Außer es ist äußerst notwendig, wusste aber nicht warum

void changeUserNameDialog(BuildContext context, MyAccountSettingsService service) {
  final TextEditingController newPrenameController = TextEditingController();
  final TextEditingController newSurnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showCustomDialog(
    context: context,
    title: 'Name ändern',
    contentBuilder: (dialogContext) => [
      TextField(
        controller: newPrenameController,
        decoration: InputDecoration(
          hintText: 'Vorname',
          hintStyle: Theme.of(dialogContext).textTheme.labelSmall,
        ),
      ),
      TextField(
        controller: newSurnameController,
        decoration: InputDecoration(
          hintText: 'Nachname',
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
      final String newPrename = newPrenameController.text;
      final String newSurname = newSurnameController.text;
      final String password = passwordController.text;

      await service.updateNameFromCurrentUser(context, newPrename, newSurname, password);
    },
  );
}