
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../functions/providers/settings/MySettingsProvider.dart';
import '../../../functions/services/snackbars/MySnackBarService.dart';
import '../../bottomSheet/MyDraggableScrollableWidget.dart';
import '../../bottomSheetItems/MyItemBottomSheet.dart';

class MySearchBarFunctions {

  static Future<void> scan(BuildContext context, String groupUUID) async {
    final result = await BarcodeScanner.scan();
    final player = AudioPlayer();

    if (result.type == ResultType.Barcode) {
      var settingsProvider = Provider.of<MySettingsProvider>(context, listen: false);
      if (settingsProvider.isVibrationEnabled) {
        Vibration.vibrate(duration: 500);
      }
      if (settingsProvider.isSoundEnabled) {
        await player.play(UrlSource('https://cdn.discordapp.com/attachments/498108545359806474/1197883476242862121/succsess.wav'));
      }
      String currentUserUUID = FirebaseAuth.instance.currentUser?.uid ?? '';

      List<Widget> bottomSheetWidgets = await MyItemBottomSheet.generateBottomSheet(
        context,
        result.rawContent,
        fromScanner: true,
        groupUUID: groupUUID,
        currentUserUUID: currentUserUUID,
      );

      showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
        },
      );
    } else if (result.type == ResultType.Cancelled) {
      MySnackBarService.showMySnackBar(context, "BarCodeScanner wurde verlassen!", isError: false);
    } else if (result.type == ResultType.Error) {
      MySnackBarService.showMySnackBar(context, "BarCode konnte nicht gescannt werden!");
    }
  }
}