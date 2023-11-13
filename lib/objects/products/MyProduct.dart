import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MyProduct extends ChangeNotifier {
  String productID;
  final String productName;
  final String selectedUserUUID;
  final int productCount;
  final int productVolumen;
  final String productVolumenType;
  final String productImageUrl;

  MyProduct({
    required this.productID,
    required this.productName,
    required this.selectedUserUUID,
    required this.productCount,
    required this.productVolumen,
    required this.productVolumenType,
    required this.productImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'productName': productName,
      'selectedUserUUID': selectedUserUUID,
      'productCount': productCount,
      'productVolumen': productVolumen,
      'productVolumenType': productVolumenType,
      'productImageUrl': productImageUrl,
    };
  }

  void updateProductUUID(MyProduct product, String newUUID) {
    product.productID = newUUID;
  }

  factory MyProduct.fromMap(Map<String, dynamic> map) {
    return MyProduct(
      productID: map['productID'] as String,
      productName: map['productName'] as String,
      selectedUserUUID: map['selectedUserUUID'] as String,
      productCount: map['productCount'] as int,
      productVolumen: map['productVolumen'] as int,
      productVolumenType: map['productVolumenType'] as String,
      productImageUrl: map['productImageUrl'] as String,
    );
  }

  factory MyProduct.fromQuery(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return MyProduct(
      productID: data['productID'] as String,
      productName: data['productName'] as String,
      selectedUserUUID: data['selectedUserUUID'] as String,
      productCount: data['productCount'] as int,
      productVolumen: data['productVolumen'] as int,
      productVolumenType: data['productVolumenType'] as String,
      productImageUrl: data['productImageUrl'] as String,
    );
  }
}