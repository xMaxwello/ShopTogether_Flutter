import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/settings/MyAccountSettingsProvider.dart';


class MyAccountSettingsWidget extends StatelessWidget {
  final VoidCallback onBack;

  const MyAccountSettingsWidget({super.key, required this.onBack});

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
            ListTile(
              title: const Text('E-Mail ändern'),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Passwort ändern'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                String newPassword = 'test1234';
                accountSettingsProvider.updatePassword(context, newPassword);
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
            ElevatedButton(
              onPressed: onBack,
              child: const Text('Zurück zu den Einstellungen'),
            ),
          ],
        );
      },
    );
  }
}