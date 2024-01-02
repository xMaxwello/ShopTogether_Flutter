import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MySearchProvider extends ChangeNotifier {
  String _searchedText = "";
  String _barcode = "";
  bool _isSearching = false;
  int _sizeOfSearchedProducts = 45;

  String get searchedText => _searchedText;
  String get barcode => _barcode;
  bool get isSearching => _isSearching;
  int get sizeOfSearchedProducts => _sizeOfSearchedProducts;

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

  void updateSizeOfSearchedProducts(int sizeOfSearchedProducts) {
    _sizeOfSearchedProducts = sizeOfSearchedProducts;
    notifyListeners();
  }
}