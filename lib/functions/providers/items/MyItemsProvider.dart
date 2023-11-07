import 'package:flutter/foundation.dart';

class MyItemsProvider extends ChangeNotifier {
  bool _isGroup = true;
  String _selectedGroupUUID = "";
  

  bool get isGroup => _isGroup;
  String get selectedGroupUUID => _selectedGroupUUID;


  void updateIsGroup(bool isGroup) {
    _isGroup = isGroup;
    notifyListeners();
  }

  void updateItemIndex(String selectedGroupUUID) {
    _selectedGroupUUID = selectedGroupUUID;
    notifyListeners();
  }
}