import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/functions/dialog/settingsDialog/changeEmailDialog.dart';
import 'package:shopping_app/functions/dialog/settingsDialog/changePasswordDialog.dart';
import 'package:shopping_app/functions/dialog/settingsDialog/deleteAccountDialog.dart';
import 'package:shopping_app/functions/dialog/settingsDialog/changeUserNameDialog.dart';

/**
 * The body of the MyAccountSettingsPage
 * */
class MyAccountSettingsWidget extends StatelessWidget {

  const MyAccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {

    List<String> titles = [
      'Name ändern',
      'E-Mail ändern',
      'Passwort ändern',
      'Account löschen',
    ];

    List<Function()> actions = [
          () => changeUserNameDialog(context),
          () => changeEmailDialog(context),
          () => changePasswordDialog(context),
          () => deleteAccountDialog(context),
    ];

    List<Widget> listTiles = [];
    for (int i = 0; i < titles.length; i++) {
      bool isDeleteAccount = i == titles.length - 1;
      listTiles.add(
        ListTile(
          title: Text(
            titles[i],
            style: i == titles.length - 1 ? GoogleFonts.tiltNeon(
              textStyle: const TextStyle(color: Colors.red, fontSize: 14),
            ) : Theme.of(context).textTheme.labelSmall,
          ),
          trailing: Icon(
            isDeleteAccount ? Icons.delete_forever : Icons.edit,
            color: isDeleteAccount ? Colors.red : const Color(0xff959595),
          ),
          onTap: actions[i],
        ),
      );
    }

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
                    .titleLarge
            ),
          ),
        ),

        const SizedBox(height: 25),

        Column(children: listTiles),

        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
                "Zurück",
                style: Theme.of(context).textTheme.displaySmall
            ),
          ),
        ),
      ],
    );
  }
}