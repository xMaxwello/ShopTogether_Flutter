import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../exceptions/MyCustomException.dart';
import '../../../../objects/users/MyUsers.dart';

class UserService {

  void addUser(MyUser myUser) {

    try {

      String uuid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection("users").doc(uuid).set(myUser.toMap());
    } catch(e) {

      print(e.toString());
    }
  }

  void removeUser(String uuid) async {

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
  void removeCurrentUserCompletely() async {

    User user = FirebaseAuth.instance.currentUser!;

    removeUser(user.uid);
    await user.delete();
  }

  void updateUser(String uuid, MyUser myUser) {

  }

  ///[MyCustomException] Keys:
  ///- snapchot-not-exists: the snapchot doesn't exists of the userUuid
  Future<void> addGroupUUIDsFromUser(String userUuid, String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(userUuid);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {
      MyUser user = MyUser.fromMap(snapshot.data() as Map<String, dynamic>);
      List<String> groupUUIDsFromUser = user.groupUUIDs;
      groupUUIDsFromUser.add(groupUUID);

      FirebaseFirestore.instance
          .collection("users")
          .doc(userUuid)
          .update({"groupUUIDs": groupUUIDsFromUser});
    } else {

      throw MyCustomException("the snapchot doesn't exists of the $userUuid", "snapchot-not-exists");
    }
  }

  ///[MyCustomException] Keys:
  ///- not-found-groupuuid: GroupUUID was not in list of the user!
  void removeGroupUUIDsFromUser(String userUuid, String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("groups").doc(userUuid);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (snapshot.exists) {
      MyUser user = MyUser.fromMap(snapshot.data() as Map<String, dynamic>);
      List<String> groupUUIDsFromUser = user.groupUUIDs;
      bool isExecuted = groupUUIDsFromUser.remove(groupUUID);

      if (isExecuted) {

        FirebaseFirestore.instance
            .collection("users")
            .doc(userUuid)
            .update({"groupUUIDs": groupUUIDsFromUser});
      } else {

        throw MyCustomException("GroupUUID was not in list of the user!", "not-found-groupuuid");
      }
    }
  }
}