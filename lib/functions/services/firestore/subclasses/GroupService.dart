import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/UserService.dart';

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
      myGroup.updateGroupUUID(myGroup, ref.id);
      myGroup.updateUserUUIDs(myGroup, [uuidFromCurrentUser]);
      await ref.set(myGroup.toMap());

      ///add the uuid from group in the current user
      await MyFirestoreService.userService.addGroupUUIDsFromUser(uuidFromCurrentUser, ref.id);
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
}