import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettingsProvider with ChangeNotifier {
  bool _isBiometricLock = false;
  bool _isNotificationsEnabled = false;
  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;
  bool _isDarkThemeEnabled = false;

  MySettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isBiometricLock = prefs.getBool('biometricLock') ?? false;
    _isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    _isVibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    _isSoundEnabled = prefs.getBool('soundEnabled') ?? true;
    _isDarkThemeEnabled = prefs.getBool('darkThemeEnabled') ?? false;
    notifyListeners();
  }

  bool get isBiometricLock => _isBiometricLock;
  bool get isNotificationsEnabled => _isNotificationsEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isDarkThemeEnabled => _isDarkThemeEnabled;


  void updateIsBiometricLock(bool value) async {
    _isBiometricLock = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricLock', value);
  }

  void updateIsNotificationsEnabled(bool value) async {
    _isNotificationsEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  void updateIsVibrationEnabled(bool value) async {
    _isVibrationEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationEnabled', value);
  }

  void updateIsSoundEnabled(bool value) async {
    _isSoundEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
  }

  ThemeMode get currentThemeMode => _isDarkThemeEnabled ? ThemeMode.dark : ThemeMode.light;

  void updateIsDarkThemeEnabled(bool value) async {
    _isDarkThemeEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkThemeEnabled', value);
  }

}
