import 'package:flutter/foundation.dart';

class MyMemberProvider extends ChangeNotifier {
  bool _isShowToken = false;
  String _token = "";

  bool get isShowToken => _isShowToken;
  String get token => _token;

  void updateIsShowToken(bool isShowToken) {
    _isShowToken = isShowToken;
    notifyListeners();
  }

  void updateToken(String token) {
    _token = token;
    notifyListeners();
  }
}