import 'package:flutter/cupertino.dart';

class MyLoginProvider extends ChangeNotifier {
  Widget? _widget;
  bool _animate = false;

  Widget? get widget => _widget;
  bool get animate => _animate;

  void updateWidget(Widget widget) {
    _widget = widget;
    notifyListeners();
  }

  void updateAnimation() {
    _animate = !_animate;
    notifyListeners();
  }
}