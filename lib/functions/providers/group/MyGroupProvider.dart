import 'package:flutter/cupertino.dart';

class MyGroupProvider extends ChangeNotifier {
  bool _isShowWidget = false;

  bool get isShowWidget => _isShowWidget;

  void updateShowWidget(bool isShowWidget) {
    _isShowWidget = isShowWidget;
    notifyListeners();
  }
}