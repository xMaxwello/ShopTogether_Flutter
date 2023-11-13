import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';

class MySettingsWidget extends StatefulWidget {
  const MySettingsWidget({super.key});

  @override
  State<MySettingsWidget> createState() => _MySettingsWidgetState();
}

class _MySettingsWidgetState extends State<MySettingsWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<MySettingsProvider>(
        builder: (BuildContext context, MySettingsProvider settingsProvider,
            Widget? child) {
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
                        style: Theme.of(context).textTheme.headlineLarge
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 10),
                        ),
                      ),
                      child: Card(
                        color: Theme.of(context).cardTheme.color,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Vorname Nachname",
                                style: Theme.of(context).textTheme.titleLarge
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Accounteinstellungen",
                                    style: Theme.of(context).textTheme.bodySmall
                                  ),
                                  Icon(
                                      Icons.arrow_forward,
                                      size: Theme.of(context).iconTheme.size,
                                      color: Colors.black54)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  ListTile(
                    title: Text(
                      "Mit Fingerabdruck/FaceID sichern",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: settingsProvider.isBiometricLock,
                      onChanged: (value) {
                          settingsProvider.updateIsBiometricLock(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Push-Benachrichtigung erlauben",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: settingsProvider.isNotificationsEnabled,
                      onChanged: (value) {
                          settingsProvider.updateIsNotificationsEnabled(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Vibration beim Scannen",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: settingsProvider.isVibrationEnabled,
                      onChanged: (value) {
                          settingsProvider.updateIsVibrationEnabled(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "In-App Töne",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: settingsProvider.isSoundEnabled,
                      onChanged: (value) {
                          settingsProvider.updateIsSoundEnabled(value);
                      },
                    ),
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
                      style: Theme.of(context).textTheme.labelMedium
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
