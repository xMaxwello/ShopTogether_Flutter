import 'package:flutter/material.dart';

class MySettingsProvider with ChangeNotifier {
  bool _isBiometricLock = false;
  bool _isNotificationsEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;
  bool _isDarkThemeEnabled = false;


  bool get isBiometricLock => _isBiometricLock;
  bool get isNotificationsEnabled => _isNotificationsEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isDarkThemeEnabled => _isDarkThemeEnabled;


  void updateIsBiometricLock(bool value) {
    _isBiometricLock = value;
    notifyListeners();
  }

  void updateIsNotificationsEnabled(bool value) {
    _isNotificationsEnabled = value;
    notifyListeners();
  }

  void updateIsVibrationEnabled(bool value) {
    _isVibrationEnabled = value;
    notifyListeners();
  }

  void updateIsSoundEnabled(bool value) {
    _isSoundEnabled = value;
    notifyListeners();
  }

  void updateIsDarkThemeEnabled(bool value) {
    _isDarkThemeEnabled = value;
    notifyListeners();
  }

}
