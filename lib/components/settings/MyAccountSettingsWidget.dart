import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/settings/MyAccountSettingsProvider.dart';


class MyAccountSettingsWidget extends StatelessWidget {

  const MyAccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAccountSettingsProvider>(
      builder: (BuildContext context,
          MyAccountSettingsProvider accountSettingsProvider, Widget? child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0, horizontal: 16.0),
              child: Align(
                alignment: Alignment.center,
                child: Text("Accounteinstellungen",
                  style: GoogleFonts.tiltNeon(
                      fontSize: 32,
                      color: Colors.black
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Name ändern'),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),
            ///TODO: Email Adresse wird nicht übernommen, da die neue erst verifiziert werden muss
            ListTile(
              title: const Text('E-Mail ändern'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                _changeEmailDialog(context, accountSettingsProvider);
              },
            ),
            ListTile(
              title: const Text('Passwort ändern'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                _changePasswordDialog(context, accountSettingsProvider);
              },
            ),
            ListTile(
              title: const Text('Account löschen', style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Account löschen?'),
                      content: const Text('Sind Sie sicher, dass Sie Ihren Account löschen möchten? Dies kann nicht rückgängig gemacht werden.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Abbrechen'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Löschen', style: TextStyle(color: Colors.red)),
                          onPressed: () async {
                            accountSettingsProvider.deleteAccount(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.lerp(Colors.white, Theme
                        .of(context)
                        .colorScheme
                        .primary, 0.8)),
                minimumSize: MaterialStateProperty.resolveWith<Size?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Size(200, 50);
                    }
                    return const Size(180, 40);
                  },
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                    "Zurück",
                    style: GoogleFonts.tiltNeon(
                        fontSize: 19,
                        color: Colors.white
                    )
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeEmailDialog(BuildContext context, MyAccountSettingsProvider provider) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('E-Mail ändern'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Neue E-Mail',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Aktuelles Passwort',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Ändern', style: TextStyle(color: Colors.blue)),
              onPressed: () async {
                final String newEmail = emailController.text;
                final String password = passwordController.text;

                Navigator.of(dialogContext).pop();
                await provider.updateEmail(context, newEmail, password);
              },
            ),
          ],
        );
      },
    );
  }


  void _changePasswordDialog(BuildContext context, MyAccountSettingsProvider provider) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController repeatNewPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Passwort ändern'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Altes Passwort',
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Neues Passwort',
                ),
              ),
              TextField(
                controller: repeatNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Neues Passwort wiederholen',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Ändern', style: TextStyle(color: Colors.blue)),
              onPressed: () async {
                final String oldPassword = oldPasswordController.text;
                final String newPassword = newPasswordController.text;
                final String repeatNewPassword = repeatNewPasswordController.text;

                Navigator.of(dialogContext).pop();
                await provider.updatePassword(context, oldPassword, newPassword, repeatNewPassword);
              },
            ),
          ],
        );
      },
    );
  }
}