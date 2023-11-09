import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../objects/users/MyUsers.dart';

class MyFirestore {

  static void addUser(MyUser myUser) {

    try {

      String uuid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection("users").doc(uuid).set(myUser.toMap());
    } catch(e) {

      print(e.toString());
    }
  }

  static void removeUser(String uuid) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(uuid);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {

      List<dynamic> userUUIDs = snapshot.get("groupUUIDs");
      for (var userUUID in userUUIDs) {

        FirebaseFirestore.instance.collection("groups").doc(userUUID.toString()).get().then((user) {
          if (user.exists) {

            List<String> groupUUIDs = List<String>.from(user.get("userUUIDs"));
            groupUUIDs.remove(uuid);
            user.reference.update({
              "groupUUIDs": groupUUIDs,
            });
          }
        });
      }
      ref.delete();
    }
  }

  /// removes the current user completely from the system
  ///
  static void removeCurrentUserCompletely() {

    User user = FirebaseAuth.instance.currentUser!;

    removeUser(user.uid);
    user.delete();
  }

  static void updateUser(String uuid, MyUser myUser) {

  }

  static void addGroupUUIDsFromUser(String uuid, String groupUUID) {

    FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .get()
        .then((userDoc) {
      if (userDoc.exists) {
        MyUser user = MyUser.fromMap(userDoc.data() as Map<String, dynamic>);
        List<String> groupUUIDsFromUser = user.groupUUIDs;
        groupUUIDsFromUser.add(groupUUID);

        FirebaseFirestore.instance
            .collection("users")
            .doc(uuid)
            .update({"groupUUIDs": groupUUIDsFromUser});
      }
    });
  }

  static void removeGroupUUIDsFromUser(String uuid, String groupUUID) {

  }

  static void addGroup(MyGroup myGroup) {

    try {

      String uuidFromCurrentUser = FirebaseAuth.instance.currentUser!.uid;

      ///create a new group
      DocumentReference ref = FirebaseFirestore.instance.collection("groups").doc();

      ///update uuid from goup and add user who created the group
      myGroup.updateGroupUUID(myGroup, ref.id);
      myGroup.updateUserUUIDs(myGroup, [uuidFromCurrentUser]);
      ref.set(myGroup.toMap());

      ///add the uuid from group in the current user
      addGroupUUIDsFromUser(uuidFromCurrentUser, ref.id);
    } catch(e) {

      print(e.toString());
    }
  }

  static void removeGroup(String uuid) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(uuid);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {

      List<dynamic> userUUIDs = snapshot.get("userUUIDs");
      for (var userUUID in userUUIDs) {

        FirebaseFirestore.instance.collection("users").doc(userUUID.toString()).get().then((user) {
          if (user.exists) {

            List<String> groupUUIDs = List<String>.from(user.get("groupUUIDs"));
            groupUUIDs.remove(uuid);
            user.reference.update({
              "groupUUIDs": groupUUIDs,
            });
          }
        });
      }
      ref.delete();
    }
  }

  static void updateGroup(String id, MyProduct myProduct) {

  }

  static Future<String> getUnusedProductUUID(String groupUUID) async {

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

  static void addProduct(String groupUUID, MyProduct myProduct) async {

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

  static void removeProduct(String groupUUID, String productUUID) async {

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

  static void updateProductCount(String groupUUID, String productUUID, int addCount) async {

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

  static void updateProduct(String id, MyProduct myProduct) async {

  }

}