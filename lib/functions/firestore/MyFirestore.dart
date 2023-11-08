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

  static void removeUser(String uuid) {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(uuid);

    ref.get().then((group) {

      if (group.exists) {

        List<dynamic> userUUIDs = group.get("groupUUIDs");
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
    });
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

  static void removeGroup(String uuid) {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(uuid);

    ref.get().then((group) {

      if (group.exists) {

        List<dynamic> userUUIDs = group.get("userUUIDs");
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
    });
  }

  static void updateGroup(String id, MyProduct myProduct) {

  }

  static void addProduct(String groupUUID, MyProduct myProduct) {
    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    ref.get().then((group) {
      List<Map<String, dynamic>> productsData =
      List<Map<String, dynamic>>.from(group.get("products") ?? []);
      productsData.add(myProduct.toMap());
      ref.update({"products": productsData});
    });
  }

  static void removeProduct(String groupUUID, String productUUID) {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    ref.get().then((group) {
      List<Map<String, dynamic>> productsData =
      List<Map<String, dynamic>>.from(group.get("products") ?? []);

      Map<String, dynamic>? myProduct = productsData.where((element) => element["productID"] == productUUID).firstOrNull;
      
      if (myProduct != null) {

        productsData.remove(myProduct);
        ref.update({"products": productsData});
      }
    });
  }

  static void updateProductCount(String groupUUID, String productUUID, int addCount) {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    ref.get().then((group) {
      List<Map<String, dynamic>> productsData =
      List<Map<String, dynamic>>.from(group.get("products") ?? []);

      Map<String, dynamic>? myProduct = productsData
          .where((element) => element["productID"] == productUUID)
          .firstOrNull;

      if (myProduct != null) {

        myProduct['productCount'] = myProduct['productCount'] + addCount;
        ref.update({"products": productsData});
      }
    });
  }

  static void updateProduct(String id, MyProduct myProduct) {

  }

}