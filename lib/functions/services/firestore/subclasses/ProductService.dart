
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../objects/products/MyProduct.dart';

class ProductService {

  Future<String> getUnusedProductUUID(String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {

      String productUUID;
      List<Map<String, dynamic>> productsData =
      List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

      do {
        productUUID = (Random().nextInt(999999) + 100000).toString();
      } while (productsData.any((product) => product["productID"] == productUUID));

      return productUUID;
    }

    return "0";
  }

  void addProductToGroup(String groupUUID, MyProduct myProduct) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {

      String getUUID = await getUnusedProductUUID(groupUUID);

      myProduct.updateProductUUID(myProduct, getUUID);

      List<Map<String, dynamic>> productsData =
      List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);
      productsData.add(myProduct.toMap());
      ref.update({"products": productsData});
    }
  }

  void removeProductFromGroup(String groupUUID, String productUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {

      List<Map<String, dynamic>> productsData =
      List<Map<String, dynamic>>.from(snapshot.get("products") ?? []);

      Map<String, dynamic>? myProduct = productsData.where((element) => element["productID"] == productUUID).firstOrNull;

      if (myProduct != null) {

        productsData.remove(myProduct);
        ref.update({"products": productsData});
      }
    }
  }

  void updateProductCountFromProduct(String groupUUID, String productUUID, int addCount) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {

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
  }

  void updateProductFromGroup(String groupUuid, MyProduct myProduct) async {

  }
}
