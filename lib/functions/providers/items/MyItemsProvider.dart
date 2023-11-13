import 'package:flutter/foundation.dart';

class MyItemsProvider extends ChangeNotifier {
  String _selectedGroupUUID = "";

  String get selectedGroupUUID => _selectedGroupUUID;

  void updateItemIndex(String selectedGroupUUID) {
    _selectedGroupUUID = selectedGroupUUID;
    notifyListeners();
  }
}