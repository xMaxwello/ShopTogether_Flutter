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

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot doesn't exists of the $userUuid", "snapshot-not-exists");
    }

    MyUser user = MyUser.fromMap(snapshot.data() as Map<String, dynamic>);
    List<String> groupUUIDsFromUser = user.groupUUIDs;
    groupUUIDsFromUser.add(groupUUID);

    FirebaseFirestore.instance
        .collection("users")
        .doc(userUuid)
        .update({"groupUUIDs": groupUUIDsFromUser});
  }

  ///[MyCustomException] Keys:
  ///- not-found-groupuuid: GroupUUID was not in list of the user!
  ///- snapshot-not-existent: the snapshot doesn't exists of the $userUuid
  Future<void> removeGroupUUIDsFromUser(String userUuid, String groupUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(userUuid);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot doesn't exists of the $userUuid", "snapshot-not-existent");
    }

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

  Future<bool> isUserExists(String userUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(userUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    return snapshot.exists;
  }

  ///[MyCustomException] Keys:
  ///- snapshot-not-existent: the snapshot doesn't exists of the userUuid
  Stream<MyUser> getUserAsStream(String userUuid) {
    return FirebaseFirestore.instance.collection('users').doc(userUuid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        throw MyCustomException("the snapshot doesn't exists of the $userUuid", "snapshot-not-existent");
      }
      return MyUser.fromMap(snapshot.data()!);
    });
  }

  ///[MyCustomException] Keys:
  ///- snapshot-not-existent: the snapshot doesn't exists of the userUuid
  Future<MyUser> getUserAsObject(String userUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(userUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    if (!snapshot.exists) {
      throw MyCustomException("the snapshot doesn't exists of the $userUUID", "snapshot-not-existent");
    }

    return MyUser.fromMap(snapshot.data()!);
  }

  ///[MyCustomException] Keys:
  ///- empty-fields: The required fields are empty!
  ///- not-logged-in: the user is not logged in!
  ///- wrong-password: the password is wrong
  ///- unknown-error: Unkown Error: $e
  ///
  /// - All exceptions from firebase reauthenticateWithCredential() function:
  /// - user-mismatch:
  /// Thrown if the credential given does not correspond to the user.
  /// - user-not-found:
  /// Thrown if the credential given does not correspond to any existing user.
  /// - invalid-credential:
  /// Thrown if the provider's credential is not valid. This can happen if it has already expired when calling link, or if it used invalid token(s). See the Firebase documentation for your provider, and make sure you pass in the correct parameters to the credential method.
  /// - wrong-password:
  /// Thrown if the password used in a EmailAuthProvider.credential is not correct or when the user associated with the email does not have a password.
  /// - invalid-verification-code:
  /// Thrown if the credential is a PhoneAuthProvider.credential and the verification code of the credential is not valid.
  /// - invalid-verification-id:
  /// Thrown if the credential is a PhoneAuthProvider.credential and the verification ID of the credential is not valid.
  Future<void> updateNameOfUser(String userUuid, String newPrename, String newSurname, String password) async {
    try {
      if (newPrename.isEmpty || newSurname.isEmpty || password.isEmpty) {
        throw MyCustomException('The required fields are empty!', 'empty-fields');
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw MyCustomException('the user is not logged in!', 'not-logged-in');
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
    } on FirebaseAuthException catch (e) {

      print(e.code);
      throw MyCustomException(e.message!, e.code);
    } on MyCustomException catch (e) {

      throw MyCustomException(e.message, e.keyword);
    } catch (e) {

      throw MyCustomException("Unkown Error: $e", "unknown-error");
    }
  }

  /// [MyCustomException] Keys:
  /// - snapshot-not-exists: the snapshot of the getNameOfGroup(String userUUID) doesn`t exists!
  Future<List<String>> getNameOfUser(String userUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("users").doc(userUUID);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();

    if (!snapshot.exists) {
      throw MyCustomException("the snapshot of the $getNameOfUser(String userUUID) doesn`t exists!", "snapshot-not-exists");
    }

    String prename = snapshot.get("prename");
    String surname = snapshot.get("surname");
    return [prename, surname];
  }
}