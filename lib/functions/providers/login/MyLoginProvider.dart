import 'package:flutter/cupertino.dart';

class MyLoginProvider extends ChangeNotifier {
  Widget? _widget;
  String _message = "";
  bool _animate = false;

  Widget? get widget => _widget;
  String get message => _message;
  bool get animate => _animate;

  void updateWidget(Widget widget) {
    _widget = widget;
    notifyListeners();
  }

  void updateMessage(String message) {
    _message = message;
    notifyListeners();
  }

  void updateAnimation() {
    _animate = !_animate;
    notifyListeners();
  }
}