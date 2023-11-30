import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/UserService.dart';
import 'package:shopping_app/objects/users/MyUsers.dart';

import '../../../../exceptions/MyCustomException.dart';
import '../../../../objects/groups/MyGroup.dart';
import '../../../../objects/products/MyProduct.dart';

class GroupService {

  ///[MyCustomException] Keys:
  ///- error: returns extern errors
  ///
  /// Has the [MyCustomException] of [UserService.addGroupUUIDsFromUser]
  void addGroup(MyGroup myGroup) async {

    try {

      String uuidFromCurrentUser = FirebaseAuth.instance.currentUser!.uid;

      ///create a new group
      DocumentReference ref = FirebaseFirestore.instance.collection("groups").doc();

      ///update uuid from goup and add user who created the group
      myGroup.updateGroupUUID(ref.id);
      myGroup.updateUserUUIDs([uuidFromCurrentUser]);
      myGroup.updateUserOwnerUUID(uuidFromCurrentUser);
      await ref.set(myGroup.toMap());

      ///add the uuid from group in the current user
      await MyFirestoreService.userService.addGroupUUIDsToUser(uuidFromCurrentUser, ref.id);
    } on MyCustomException catch(e) {

      throw MyCustomException("Group couldn't created: " + e.message, e.keyword);
    } catch(e) {

      throw MyCustomException(e.toString(), "error");
    }
  }

  void removeGroup(String groupUuid) async {

    DocumentReference<Map<String, dynamic>> refGroup =
    FirebaseFirestore.instance.collection("groups").doc(groupUuid);

    DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await refGroup.get();

    if (groupSnapshot.exists) {

      List<dynamic> userUUIDs = groupSnapshot.get("userUUIDs");
      for (var userUUID in userUUIDs) {

        DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection("users").doc(userUUID.toString());

        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();

        if (userSnapshot.exists) {

          List<String> groupUUIDs = List<String>.from(userSnapshot.get("groupUUIDs"));
          groupUUIDs.remove(groupUuid);
          userSnapshot.reference.update({
            "groupUUIDs": groupUUIDs,
          });
        }
      }
      refGroup.delete();
    }
  }

  void updateGroup(String groupUuid, MyProduct myProduct) {

  }

  Future<bool> isGroupExists(String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    return snapshot.exists;
  }

  ///[MyCustomException] Keys:
  ///- snapchot-not-exists: the snapchot doesn't exists of the userUuid
  Future<void> addUserUUIDToGroup(String groupUUID, String userUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {
      MyGroup group = MyGroup.fromMap(snapshot.data() as Map<String, dynamic>);
      List<String>? userUUIDsFromGroup = group.userUUIDs;
      userUUIDsFromGroup!.add(userUUID);

      FirebaseFirestore.instance
          .collection("groups")
          .doc(groupUUID)
          .update({"userUUIDs": userUUIDsFromGroup});
    } else {

      throw MyCustomException("the snapchot doesn't exists of the $groupUUID", "snapchot-not-exists");
    }
  }

  Future<int> getSizeOfMembers(String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(groupUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {

      int userLength = List<MyUser>.from(snapshot.get("userUUIDs")).length;
      return userLength;
    }

    return -1;
  }
}