import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/dialog/settingsDialog/changeBiometricsDialog.dart';
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

        ///activate biometric
        changeBiometricsDialog(_context, switchState);
      } else {

        MySnackBarService.showMySnackBar(_context, "Ihr Gerät unterstützt keine biometrischen Login!");
      }
    } else {

      bool isAvailable = await MyBiometricsAuthService.isBiometricsAvailableOnDevice();
      if (!isAvailable) {
        settingsProvider.updateIsBiometricLock(switchState);
        mySecureStorageService.updateIsBiometricActive(switchState.toString());
      }
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