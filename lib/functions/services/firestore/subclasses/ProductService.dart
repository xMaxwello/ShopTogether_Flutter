import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../exceptions/MyCustomException.dart';
import '../../../../objects/products/MyProduct.dart';

class ProductService {

  /// [MyCustomException] Keys:
  /// - snapshot-not-exists: the snapshot of the getUnusedProductUUID(String groupUUID) doesn`t exists!
  Future<String> getUnusedProductUUID(String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getProductByUUID(String productUUID) doesn`t exists!", "snapshot-not-exists");
    }

    String productUUID;
    List<Map<String, dynamic>> productsData =
    List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

    do {
      productUUID = (Random().nextInt(999999) + 100000).toString();
    } while (productsData.any((product) => product["productID"] == productUUID));

    return productUUID;
  }

  /// [MyCustomException] Keys:
  /// - snapshot-not-exists: the snapshot of the addProductToGroup(String groupUUID, MyProduct myProduct) doesn`t exists!
  void addProductToGroup(String groupUUID, MyProduct myProduct) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getProductByUUID(String productUUID) doesn`t exists!", "snapshot-not-exists");
    }

    String getUUID = await getUnusedProductUUID(groupUUID);

    myProduct.updateProductUUID(myProduct, getUUID);

    List<Map<String, dynamic>> productsData =
    List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);
    productsData.add(myProduct.toMap());
    ref.update({"products": productsData});
  }

  /// [MyCustomException] Keys:
  /// - snapshot-not-exists: the snapshot of the removeProductFromGroup(String groupUUID, String productUUID) doesn`t exists!
  void removeProductFromGroup(String groupUUID, String productUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getProductByUUID(String productUUID) doesn`t exists!", "snapshot-not-exists");
    }

    List<Map<String, dynamic>> productsData =
    List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

    Map<String, dynamic>? myProduct = productsData.where((element) => element["productID"] == productUUID).firstOrNull;

    if (myProduct != null) {

      productsData.remove(myProduct);
      ref.update({"products": productsData});
    }
  }

  /// [MyCustomException] Keys:
  /// - snapshot-not-exists: the snapshot of the updateProductCountFromProduct(String groupUUID, String productUUID, int addCount) doesn`t exists!
  void updateProductCountFromProduct(String groupUUID, String productUUID, int addCount) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getProductByUUID(String productUUID) doesn`t exists!", "snapshot-not-exists");
    }

    List<Map<String, dynamic>> productsData =
    List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

    Map<String, dynamic>? myProduct = productsData
        .where((element) => element["productID"] == productUUID)
        .firstOrNull;

    if (myProduct != null) {

      myProduct['productCount'] = myProduct['productCount'] + addCount;
      ref.update({"products": productsData});
    }
  }

  Future<void> updateSelectedUserOfProduct(String groupUUID, String productUUID, String selectedUserUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getProductByUUID(String productUUID) doesn`t exists!", "snapshot-not-exists");
    }

    List<Map<String, dynamic>> productsData =
    List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

    Map<String, dynamic>? myProduct = productsData
        .where((element) => element["productID"] == productUUID)
        .firstOrNull;

    if (myProduct != null) {

      myProduct['selectedUserUUID'] = selectedUserUUID;
      ref.update({"products": productsData});
    }
  }

  /// [MyCustomException] Keys:
  /// - snapshot-not-exists: the snapshot of the getProductByUUID(String productUUID) doesn`t exists!
  Future<MyProduct?> getProductByUUID(String groupUUID, String productUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getProductByUUID(String productUUID) doesn`t exists!", "snapshot-not-exists");
    }

    List<Map<String, dynamic>> productsData =
    List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

    Map<String, dynamic>? myProduct = productsData
        .where((element) => element["productID"] == productUUID)
        .firstOrNull;

    if (myProduct == null) {
      return null;
    }

    MyProduct product = MyProduct.fromMap(myProduct);

    return product;
  }

  Future<List<String?>?> getProductUUIDsOfSelectedUser(String groupUUID, String userUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getProductByUUID(String productUUID) doesn`t exists!", "snapshot-not-exists");
    }

    List<Map<String, dynamic>> productsData =
    List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

    List<String?>? productUUIDs = productsData
        .where((element) => element["selectedUserUUID"] == userUUID)
        .map((Map<String, dynamic> myProduct) => MyProduct.fromMap(myProduct).productID).toList();

    return productUUIDs;
  }

  Future<void> updateProductDetails(String groupUUID, String productUUID, String title, String volume, String description) async {
    DocumentReference<Map<String, dynamic>> groupRef = FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await groupRef.get();

    if (!groupSnapshot.exists) {
      throw MyCustomException("Gruppe nicht gefunden", "group-not-found");
    }

    List<Map<String, dynamic>> productsData = List<Map<String, dynamic>>.from(groupSnapshot.get("products") ?? []);

    int productIndex = productsData.indexWhere((product) => product["productID"] == productUUID);

    if (productIndex != -1) {
      productsData[productIndex]["productName"] = title;
      productsData[productIndex]["productVolumen"] = volume;
      productsData[productIndex]["productDescription"] = description;

      groupRef.update({"products": productsData});
    } else {
      throw MyCustomException("Produkt nicht gefunden", "product-not-found");
    }
  }

}
