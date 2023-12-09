import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MySearchProvider extends ChangeNotifier {
  String _searchedText = "";
  String _barcode = "";
  bool _isSearching = false;

  String get searchedText => _searchedText;
  String get barcode => _barcode;
  bool get isSearching => _isSearching;

  void updateSearchedText(String searchedText) {
    _searchedText = searchedText;
    notifyListeners();
  }

  void updateBarCode(String barcode) {
    _barcode = barcode;
    notifyListeners();
  }

  void updateIsSearching(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }
}