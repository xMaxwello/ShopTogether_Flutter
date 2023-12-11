import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';

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

  void updateProductFromGroup(String groupUuid, MyProduct myProduct) async {

  }

  /// [MyCustomException] Keys:
  /// - snapshot-not-exists: the snapshot of the getProductByUUID(String productUUID) doesn`t exists!
  Future<MyProduct?> getProductByUUID(groupUUID, String productUUID) async {

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
}
