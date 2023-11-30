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
  ///- snapshot-not-exists: the snapshot doesn't exists of the userUuid
  Future<void> addGroupUUIDsToUser(String userUuid, String groupUUID) async {

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

      throw MyCustomException("the snapshot doesn't exists of the $userUuid", "snapshot-not-exists");
    }
  }

  ///[MyCustomException] Keys:
  ///- not-found-groupuuid: GroupUUID was not in list of the user!
  void removeGroupUUIDsFromUser(String userUuid, String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(userUuid);

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

  Future<bool> isUserExists(String userUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(userUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    return snapshot.exists;
  }

  ///[MyCustomException] Keys:
  ///- snapshot-not-existent: the snapshot doesn't exists of the userUuid
  Stream<MyUser> getUserName(String userUuid) {
    return FirebaseFirestore.instance.collection('users').doc(userUuid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return MyUser.fromMap(snapshot.data()!);
      } else {
        throw MyCustomException("the snapshot doesn't exists of the $userUuid", "snapshot-not-existent");
      }
    });
  }

  ///[MyCustomException] Keys:
  ///- empty-fields: Textfelder sind leer
  ///- not-logged-in: User ist nicht angemeldet
  ///- wrong-password: Falsches Passwort eingegeben
  Future<void> updateUserName(String userUuid, String newPrename, String newSurname, String password) async {
    try {
      if (newPrename.isEmpty || newSurname.isEmpty || password.isEmpty) {
        throw MyCustomException('Bitte füllen Sie alle Felder aus.', 'empty-fields');
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw MyCustomException('Sie sind nicht angemeldet.', 'not-logged-in');
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await FirebaseFirestore.instance.collection('users').doc(userUuid).update({
        'prename': newPrename,
        'surname': newSurname,
      });
    } on MyCustomException catch (e) {
        throw MyCustomException(e.message, e.keyword);

    } catch (e) {
      throw MyCustomException("Unbekannter Fehler: $e", "unknown-error");
    }
  }

}