import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySettingsWidget extends StatefulWidget {
  const MySettingsWidget({super.key});

  @override
  _MySettingsWidgetState createState() => _MySettingsWidgetState();
}

class _MySettingsWidgetState extends State<MySettingsWidget> {
  bool _isBiometricLock = false;
  bool _isNotificationsEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
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
        const Card(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Padding(
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
        ListTile(
          title: const Text("Vibration beim Scannen"),
          trailing: Switch(
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
            value: _isSoundEnabled,
            onChanged: (value) {
              setState(() {
                _isSoundEnabled = value;
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
              "Abmelden",
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
