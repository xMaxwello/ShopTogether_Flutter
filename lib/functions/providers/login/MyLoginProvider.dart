import 'package:flutter/cupertino.dart';

class MyLoginProvider extends ChangeNotifier {
  Widget? _widget;
  List<bool> _showPasswords = [];

  Widget? get widget => _widget;
  List<bool> get showPasswords => _showPasswords;

  void updateWidget(Widget widget) {
    _widget = widget;
    notifyListeners();
  }

  void updateShowPasswords(List<bool> showPasswords) {
    _showPasswords = showPasswords;
    notifyListeners();
  }
}