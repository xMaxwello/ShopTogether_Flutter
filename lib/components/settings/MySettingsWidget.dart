import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/settings/MyUserCard.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';
import 'package:shopping_app/functions/services/settings/MySettingsFunctions.dart';
import 'package:shopping_app/pages/MyAccountSettingsPage.dart';

class MySettingsWidget extends StatefulWidget {
  const MySettingsWidget({super.key});

  @override
  State<MySettingsWidget> createState() => _MySettingsWidgetState();
}

class _MySettingsWidgetState extends State<MySettingsWidget> {

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<MySettingsProvider>(context, listen: false);

    List<String> settingTitles = [
      "Mit Fingerabdruck/FaceID sichern",
      "Push-Benachrichtigung erlauben",
      "Vibration beim Scannen",
      "In-App Töne",
      "Dark Theme"
    ];

    ///variables for the provider
    List<bool> settingProviderValues = [
      settingsProvider.isBiometricLock,
      settingsProvider.isNotificationsEnabled,
      settingsProvider.isVibrationEnabled,
      settingsProvider.isSoundEnabled,
      settingsProvider.isDarkThemeEnabled
    ];

    ///functions for the switchs
    MySettingsFunctions mySettingsFunctions = MySettingsFunctions(context);
    List<ValueChanged<bool>> settingsFunctions = [
      mySettingsFunctions.biometricFunction,
      mySettingsFunctions.notificationFunction,
      mySettingsFunctions.vibrationFunction,
      mySettingsFunctions.soundFunction,
      mySettingsFunctions.darkThemeFunction,
    ];

    List<Widget> listTiles = [];
    for (int i = 0; i < settingTitles.length; i++) {
      listTiles.add(
        ListTile(
          title: Text(
            settingTitles[i],
            style: Theme.of(context).textTheme.labelSmall,
          ),
          trailing: Switch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: settingProviderValues[i],
            onChanged: (bool value) {
              settingsFunctions[i](value);
            },
          ),
        ),
      );
    }

    return Consumer<MySettingsProvider>(
        builder: (BuildContext context, MySettingsProvider settingsProvider, Widget? child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 16.0, right: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            "Einstellungen",
                            style: Theme.of(context).textTheme.titleLarge
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyAccountSettingsPage(),
                        ),
                        );
                      },
                    child: const MyUserCard(),
                    ),
                    Column(
                        children: listTiles
                    ),
                  ],
                ),

                const SizedBox(height: 15,),

                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                        "Abmelden",
                        style: Theme.of(context).textTheme.displaySmall
                    ),
                  ),
                ),
              ],
            );
        });
  }
}
