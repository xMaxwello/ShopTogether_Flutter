import 'package:flutter/services.dart';

class MyClipBoardService {

  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text))
        .then((_) => print('Inhalt in Zwischenablage kopiert: $text'))
        .catchError((error) => print('Fehler beim Kopieren in die Zwischenablage: $error'));
  }
}