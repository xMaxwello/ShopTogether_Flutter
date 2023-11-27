import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/services/storage/MySecureStorageService.dart';

import '../../providers/settings/MySettingsProvider.dart';

class MySettingsFunctions {

  late MySettingsProvider settingsProvider;

  MySettingsFunctions(BuildContext context) {
    settingsProvider = Provider.of<MySettingsProvider>(context, listen: false);
  }

  void biometricFunction(bool switchState) {

    settingsProvider.updateIsBiometricLock(switchState);

    MySecureStorageService mySecureStorageService = MySecureStorageService();
    if (switchState) {

      mySecureStorageService.updateUserInStorage("dafobi3589@othao.com", "mo1234");
    } else {

      mySecureStorageService.deleteUsers();
    }
  }
  void notificationFunction(bool switchState) {

    settingsProvider.updateIsNotificationsEnabled(switchState);
  }
  void vibrationFunction(bool switchState) {

    settingsProvider.updateIsVibrationEnabled(switchState);
  }
  void soundFunction(bool switchState) {

    settingsProvider.updateIsSoundEnabled(switchState);
  }
  void darkThemeFunction(bool switchState) {

    settingsProvider.updateIsDarkThemeEnabled(switchState);
  }
}