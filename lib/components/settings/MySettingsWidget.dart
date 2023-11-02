import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/settings/MySettingsProvider.dart';
import 'package:shopping_app/components/settings/MyUserCard.dart';

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
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Einstellungen",
                        style: GoogleFonts.tiltNeon(
                            fontSize: 32,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  const MyUserCard(),
                  ListTile(
                    title: const Text("Mit Fingerabdruck/FaceID sichern"),
                    trailing: Switch(
                      activeColor: Color.lerp(Colors.white, Theme
                          .of(context)
                          .colorScheme
                          .primary, 0.9),
                      value: settingsProvider.isBiometricLock,
                      onChanged: (value) {
                          settingsProvider.updateIsBiometricLock(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("Push-Benachrichtigung erlauben"),
                    trailing: Switch(
                      activeColor: Color.lerp(Colors.white, Theme
                          .of(context)
                          .colorScheme
                          .primary, 0.9),
                      value: settingsProvider.isNotificationsEnabled,
                      onChanged: (value) {
                          settingsProvider.updateIsNotificationsEnabled(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("Vibration beim Scannen"),
                    trailing: Switch(
                      activeColor: Color.lerp(Colors.white, Theme
                          .of(context)
                          .colorScheme
                          .primary, 0.9),
                      value: settingsProvider.isVibrationEnabled,
                      onChanged: (value) {
                          settingsProvider.updateIsVibrationEnabled(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("In-App Töne"),
                    trailing: Switch(
                      activeColor: Color.lerp(Colors.white, Theme
                          .of(context)
                          .colorScheme
                          .primary, 0.9),
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
                      "Abmelden",
                      style: GoogleFonts.tiltNeon(
                          fontSize: 19,
                          color: Colors.white
                      )
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
