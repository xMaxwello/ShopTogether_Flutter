import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyItemsProvider extends ChangeNotifier {
  String _selectedGroupUUID = "";
  bool _isGroup = true;

  String get selectedGroupUUID => _selectedGroupUUID;
  bool get isGroup => _isGroup;

  void updateItemIndex(String selectedGroupUUID) {
    _selectedGroupUUID = selectedGroupUUID;
    notifyListeners();
  }

  void updateIsGroup(bool isGroup) {
    _isGroup = isGroup;
    notifyListeners();
  }
}