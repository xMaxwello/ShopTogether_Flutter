import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

class MyGroup extends ChangeNotifier {

  String groupUUID;
  final String groupName;
  final List<String> userUUIDs;
  final List<MyProduct> products;

  MyGroup({
    required this.groupUUID,
    required this.groupName,
    required this.userUUIDs,
    required this.products,
  });

  void updateGroupUUID(MyGroup group, String newUUID) {
    group.groupUUID = newUUID;
  }

  Map<String, dynamic> toMap() {
    return {
      'groupUUID': groupUUID,
      'groupName': groupName,
      'userUUIDs': userUUIDs,
      'products': products,
    };
  }

  factory MyGroup.fromMap(Map<String, dynamic> map) {
    return MyGroup(
      groupUUID: map['groupUUID'] as String,
      groupName: map['groupName'] as String,
      userUUIDs: (map['userUUIDs'] as List<dynamic>).cast<String>(),
      products: (map['products'] as List<dynamic>).map((productMap) => MyProduct.fromMap(productMap)).toList(),
    );
  }

  factory MyGroup.fromQuery(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final List<String> userUUIDs = (data['userUUIDs'] as List<dynamic>).cast<String>();
    final List<Map<String, dynamic>> productMaps = (data['products'] as List<dynamic>).cast<Map<String, dynamic>>();
    final List<MyProduct> products = productMaps.map((productMap) => MyProduct.fromMap(productMap)).toList();

    return MyGroup(
      groupUUID: data['groupUUID'] as String,
      groupName: data['groupName'] as String,
      userUUIDs: userUUIDs,
      products: products,
    );
  }
}