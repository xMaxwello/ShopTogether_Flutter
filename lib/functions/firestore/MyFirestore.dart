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

      myGroup.updateGroupUUID(myGroup, ref.id);
      ref.set(myGroup.toMap());

      ///add the uuid from group in the current user
      addGroupUUIDsFromUser(uuidFromCurrentUser, ref.id);
    } catch(e) {

      print(e.toString());
    }
  }

  static void removeGroup(String id) {

  }

  static void updateGroup(String id, MyProduct myProduct) {

  }

  static void addProduct(MyProduct myProduct) {///TODO: Hier gibts noch fehler: MyProducts wird in Groups geschrieben doc(id) verwenden
    FirebaseFirestore.instance.collection("groups").doc().set({
      "products": myProduct.toMap()
    });
  }

  static void removeProduct(String id) {

  }

  static void updateProduct(String id, MyProduct) {

  }

}