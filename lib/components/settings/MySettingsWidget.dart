import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySettingsWidget extends StatefulWidget {
  const MySettingsWidget({super.key});

  @override
  _MySettingsWidgetState createState() => _MySettingsWidgetState();
}

class _MySettingsWidgetState extends State<MySettingsWidget> {

  ///TODO: Eventuell eine Farbenauswahl für das Theme implementieren
  ///TODO: Gedanken über struktur machen: Feste  Button größe?
  ///TODO: Prüf, ob du ein Provider benutzt. Also ein Provider für alle Settings
  bool _isBiometricLock = false;
  bool _isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text("Mit Fingerabdruck sichern"),
          trailing: Switch(
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
            value: _isNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _isNotificationsEnabled = value;
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 100.0),
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Ausloggen",
                style: GoogleFonts.tiltNeon(
                  fontSize: 19,
                  color: Colors.white
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}
