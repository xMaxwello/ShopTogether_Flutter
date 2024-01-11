import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyProduct extends ChangeNotifier {
  String? productID;
  String barcode;
  final String productName;
  final String selectedUserUUID;
  final int productCount;
  final String productVolumen;
  final String productVolumenType;
  final String productImageUrl;
  final String productDescription;

  MyProduct({
    this.productID,
    required this.barcode,
    required this.productName,
    required this.selectedUserUUID,
    required this.productCount,
    required this.productVolumen,
    required this.productVolumenType,
    required this.productImageUrl,
    required this.productDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'barcode': barcode,
      'productName': productName,
      'selectedUserUUID': selectedUserUUID,
      'productCount': productCount,
      'productVolumen': productVolumen,
      'productVolumenType': productVolumenType,
      'productImageUrl': productImageUrl,
      'productDescription': productDescription,
    };
  }

  void updateProductUUID(MyProduct product, String newUUID) {
    product.productID = newUUID;
  }

  int compareSelectedUserTo(MyProduct other) {

    if (selectedUserUUID.compareTo(other.selectedUserUUID) < 0) {
      return -1;
    } else if (selectedUserUUID.compareTo(other.selectedUserUUID) > 0) {
      return 1;
    }
    return 0;
  }

  int compareNameTo(MyProduct other) {

    if (productName.compareTo(other.productName) < 0) {
      return -1;
    } else if (productName.compareTo(other.productName) > 0) {
      return 1;
    }
    return 0;
  }

  factory MyProduct.fromMap(Map<String, dynamic> map) {
    return MyProduct(
      productID: map['productID'] as String,
      barcode: map['barcode'] as String,
      productName: map['productName'] as String,
      selectedUserUUID: map['selectedUserUUID'] as String,
      productCount: map['productCount'] as int,
      productVolumen: map['productVolumen'] as String,
      productVolumenType: map['productVolumenType'] as String,
      productImageUrl: map['productImageUrl'] as String,
      productDescription: map['productDescription'] as String,
    );
  }

  factory MyProduct.fromQuery(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return MyProduct(
      productID: data['productID'] as String,
      barcode: data['barcode'] as String,
      productName: data['productName'] as String,
      selectedUserUUID: data['selectedUserUUID'] as String,
      productCount: data['productCount'] as int,
      productVolumen: data['productVolumen'] as String,
      productVolumenType: data['productVolumenType'] as String,
      productImageUrl: data['productImageUrl'] as String,
      productDescription: data['productDescription'] as String,
    );
  }
}