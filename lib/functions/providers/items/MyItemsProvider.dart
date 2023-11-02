import 'package:flutter/foundation.dart';

class MyItemsProvider extends ChangeNotifier {
  bool _isGroup = true;
  //List _elements = [];

  bool get isGroup => _isGroup;
  //List get elements => _elements;


  void updateIsGroup(bool isGroup) {
    _isGroup = isGroup;
    notifyListeners();
  }

  /*
  void updateElements(List elements) {
    _elements = elements;
    notifyListeners();
  }*/
}