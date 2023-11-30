import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

class MyGroup extends ChangeNotifier {

  String? groupUUID;
  String groupName;
  String? userOwnerUUID;
  List<String>? userUUIDs;
  List<MyProduct> products;

  MyGroup({
    this.groupUUID,
    required this.groupName,
    this.userOwnerUUID,
    this.userUUIDs,
    required this.products,
  });

  void updateGroupUUID(String newUUID) {
    this.groupUUID = newUUID;
  }

  void updateUserOwnerUUID(String newUUID) {
    this.userOwnerUUID = newUUID;
  }

  void updateUserUUIDs(List<String> userUUIDs) {
    this.userUUIDs = userUUIDs;
  }

  Map<String, dynamic> toMap() {
    return {
      'groupUUID': groupUUID,
      'groupName': groupName,
      'userOwnerUUID': userOwnerUUID,
      'userUUIDs': userUUIDs,
      'products': products,
    };
  }

  factory MyGroup.fromMap(Map<String, dynamic> map) {
    return MyGroup(
      groupUUID: map['groupUUID'] as String,
      groupName: map['groupName'] as String,
      userOwnerUUID: map['userOwnerUUID'] as String?,
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
      userOwnerUUID: data['userOwnerUUID'] as String,
      userUUIDs: userUUIDs,
      products: products,
    );
  }
}