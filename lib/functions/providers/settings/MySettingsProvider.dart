import 'package:flutter/material.dart';

class MySettingsProvider with ChangeNotifier {
  bool _isSettingsPage = false;

  bool get isSettingsPage => _isSettingsPage;

  set isSettingsPage(bool value) { //TODO: Überarbeitung-1: benutze immer wenn du was updaten möchte das Schlüsselwort update am Anfang der Funktion + Benutze eine void funktion wie bei den anderen Providern, einheitlich arbeiten
    _isSettingsPage = value;
    notifyListeners();
  }
}
