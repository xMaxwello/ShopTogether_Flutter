import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/services/biometricsAuth/MyBiometricsAuthService.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
import 'package:shopping_app/functions/services/storage/MySecureStorageService.dart';

import '../../providers/settings/MySettingsProvider.dart';

class MySettingsFunctions {

  late MySettingsProvider settingsProvider;
  late final BuildContext _context;

  MySettingsFunctions(BuildContext context) {
    settingsProvider = Provider.of<MySettingsProvider>(context, listen: false);
    _context = context;
  }

  void biometricFunction(bool switchState) async {

    MySecureStorageService mySecureStorageService = MySecureStorageService();
    if (switchState) {

      if (await MyBiometricsAuthService.isBiometricsAvailableOnDevice()) {

        settingsProvider.updateIsBiometricLock(switchState);
        mySecureStorageService.updateUserInStorage("dafobi3589@othao.com", "mo1234"); ///TODO: ändern
      } else {

        MySnackBarService.showMySnackBar(_context, "Ihr Gerät unterstützt keine biometrischen Login!");
      }
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