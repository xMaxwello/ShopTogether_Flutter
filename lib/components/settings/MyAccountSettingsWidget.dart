import 'package:flutter/material.dart';

class MyAccountSettingsWidget extends StatelessWidget {
  final VoidCallback onBack;

  const MyAccountSettingsWidget({Key? key, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onBack,
          child: Text('Zurück zu den Einstellungen'),
        ),
      ],
    );
  }
}

///TODO: Lukas 'Alles nur Platzhalter um zu testen ob sich die Seite aktualisiert'