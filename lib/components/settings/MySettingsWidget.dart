import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySettingsWidget extends StatefulWidget {
  const MySettingsWidget({super.key});

  @override
  _MySettingsWidgetState createState() => _MySettingsWidgetState();
}

class _MySettingsWidgetState extends State<MySettingsWidget> {

  //TODO: Booleans im Provider speichern (Alle Settings in einem Provider)
  bool _isBiometricLock = false;
  bool _isNotificationsEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
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
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.05),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Vorname Nachname",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Accounteinstellungen",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.black54)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text("Mit Fingerabdruck/FaceID sichern"),
              trailing: Switch(
                activeColor: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.9),
                value: _isBiometricLock,
                onChanged: (value) {
                  setState(() {
                    _isBiometricLock = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Push-Benachrichtigung erlauben"),
              trailing: Switch(
                activeColor: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.9),
                value: _isNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _isNotificationsEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Vibration beim Scannen"),
              trailing: Switch(
                activeColor: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.9),
                value: _isVibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    _isVibrationEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("In-App Töne"),
              trailing: Switch(
                activeColor: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.9),
                value: _isSoundEnabled,
                onChanged: (value) {
                  setState(() {
                    _isSoundEnabled = value;
                  });
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
            backgroundColor: MaterialStateProperty.all(Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.8)),
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
}
