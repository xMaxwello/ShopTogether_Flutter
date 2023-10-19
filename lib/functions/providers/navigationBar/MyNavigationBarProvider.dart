import 'package:flutter/foundation.dart';

class MyNavigationBarProvider extends ChangeNotifier {
  List<bool> _isNavigationSelected = [true, false];

  List<bool> get isNavigationSelected => _isNavigationSelected;

  void updateNavigationSelected(List<bool> isNavigationSelected) {
    _isNavigationSelected = isNavigationSelected;
    notifyListeners();
  }
}