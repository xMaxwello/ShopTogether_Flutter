import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

class MyGroup extends ChangeNotifier {
  final String groupID;
  final String groupName;
  final List<String> userUUIDs;
  final List<MyProduct> products;

  MyGroup({
    required this.groupID,
    required this.groupName,
    required this.userUUIDs,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'groupName': groupName,
      'userUUIDs': userUUIDs,
      'products': products,
    };
  }

  factory MyGroup.fromQuery(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final List<String> userUUIDs = (data['userUUIDs'] as List<dynamic>).cast<String>();
    final List<Map<String, dynamic>> productMaps = (data['products'] as List<dynamic>).cast<Map<String, dynamic>>();
    final List<MyProduct> products = productMaps.map((productMap) => MyProduct.fromMap(productMap)).toList();

    return MyGroup(
      groupID: data['groupID'] as String,
      groupName: data['groupName'] as String,
      userUUIDs: userUUIDs,
      products: products,
    );
  }
}