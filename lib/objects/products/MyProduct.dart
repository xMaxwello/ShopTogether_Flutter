import 'package:flutter/foundation.dart';

class MyProduct extends ChangeNotifier {
  final String productID;
  final String productName;
  final String selectedUserUUID;
  final int productCount;
  final String productImageUrl;

  MyProduct({
    required this.productID,
    required this.productName,
    required this.selectedUserUUID,
    required this.productCount,
    required this.productImageUrl,
  });
}