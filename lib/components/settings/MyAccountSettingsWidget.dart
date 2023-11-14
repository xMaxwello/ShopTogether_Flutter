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
              padding: const EdgeInsets.only(
                  top: 40, left: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.center,
                child: Text("Accounteinstellungen",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge
                ),
              ),
            ),
            ListTile(
              title: Text('Name ändern',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.edit, color: Color(0xff959595)),
              onTap: () {},
            ),
            ///TODO: Email Adresse wird nicht übernommen, da die neue erst verifiziert werden muss
            ListTile(
              title: Text('E-Mail ändern',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.edit, color: Color(0xff959595)),
              onTap: () {
                _changeEmailDialog(context, accountSettingsProvider);
              },
            ),
            ListTile(
              title: Text('Passwort ändern',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.edit, color: Color(0xff959595)),
              onTap: () {
                _changePasswordDialog(context, accountSettingsProvider);
              },
            ),
            ListTile(
              title: Text('Account löschen',
                  style: GoogleFonts.tiltNeon(
                  textStyle: const TextStyle(color: Colors.red),
                  ),
              ),
              trailing: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Account löschen?',
                      style: Theme.of(context).textTheme.titleLarge,
                      ),
                      content: Text('Sind Sie sicher, dass Sie Ihren Account löschen möchten? Dies kann nicht rückgängig gemacht werden.',
                      style: Theme.of(context).textTheme.bodySmall,
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Abbrechen',
                          style: GoogleFonts.tiltNeon(),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Löschen', style: GoogleFonts.tiltNeon(
                            textStyle: const TextStyle(color: Colors.red),
                          ),
                          ),
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
          title: Text('Passwort ändern',
              style: Theme.of(context).textTheme.titleLarge,
        ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Altes Passwort',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Neues Passwort',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              TextField(
                controller: repeatNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Neues Passwort wiederholen',
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