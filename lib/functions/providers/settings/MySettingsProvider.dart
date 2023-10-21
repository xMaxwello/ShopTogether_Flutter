import 'package:flutter/material.dart';

class MySettingsProvider with ChangeNotifier {
  bool _isSettingsPage = false;

  bool get isSettingsPage => _isSettingsPage;

  set isSettingsPage(bool value) {
    _isSettingsPage = value;
    notifyListeners();
  }
}
