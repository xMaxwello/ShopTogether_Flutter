import 'package:flutter/cupertino.dart';

class MyLoginProvider extends ChangeNotifier {
  Widget? _widget;

  Widget? get widget => _widget;

  void updateWidget(Widget widget) {
    _widget = widget;
    notifyListeners();
  }
}