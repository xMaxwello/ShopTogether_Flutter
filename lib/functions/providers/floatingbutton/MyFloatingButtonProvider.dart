import 'package:flutter/foundation.dart';

class MyFloatingButtonProvider extends ChangeNotifier {
  bool _isExtended = true;

  bool get isExtended => _isExtended;

  void updateExtended(bool isExtended) {
    _isExtended = isExtended;
    notifyListeners();
  }
}