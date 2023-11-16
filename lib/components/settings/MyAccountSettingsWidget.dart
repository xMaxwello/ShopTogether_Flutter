import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/services/settings/MyAccountSettingsService.dart';
import 'package:shopping_app/functions/dialog/changeEmailDialog.dart';
import 'package:shopping_app/functions/dialog/changePasswordDialog.dart';
import 'package:shopping_app/functions/dialog/deleteAccountDialog.dart';

///TODO: Email Adresse wird nicht übernommen, da die neue erst verifiziert werden muss
///TODO: Funktion für 'Name ändern' muss noch implementiert werden

class MyAccountSettingsWidget extends StatelessWidget {

  const MyAccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<MyAccountSettingsService>(context, listen: false);

    List<String> titles = [
      'Name ändern',
      'E-Mail ändern',
      'Passwort ändern',
      'Account löschen',
    ];

    List<Function()> actions = [
          () {}, // Funktion für 'Name ändern'
          () => changeEmailDialog(context, service),
          () => changePasswordDialog(context, service),
          () => deleteAccountDialog(context, service),
    ];

    List<Widget> listTiles = [];
    for (int i = 0; i < titles.length; i++) {
      bool isDeleteAccount = i == titles.length - 1;
      listTiles.add(
        ListTile(
          title: Text(
            titles[i],
            style: i == titles.length - 1 ? GoogleFonts.tiltNeon(
              textStyle: const TextStyle(color: Colors.red),
            ) : Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Icon(
            isDeleteAccount ? Icons.delete_forever : Icons.edit,
            color: isDeleteAccount ? Colors.red : const Color(0xff959595),
          ),
          onTap: actions[i],
        ),
      );
    }

    return Consumer<MyAccountSettingsService>(
      builder: (BuildContext context,
          MyAccountSettingsService service, Widget? child) {
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

            const SizedBox(height: 25),

            Column(children: listTiles),

            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)),
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
}