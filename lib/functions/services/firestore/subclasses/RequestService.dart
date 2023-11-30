import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';

import '../../../../exceptions/MyCustomException.dart';
import '../../../../objects/requests/MyRequestGroup.dart';
import '../MyFirestoreService.dart';

class RequestService {

  /// [MyCustomException] Keys:
  /// - user-not-logged-in: the user is not logged in!
  void addRequestForSession(MyRequestKey myRequestKey) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("requestKeys").doc();

    int generatedRequestCode = await generateNotUsedRequestCode();
    myRequestKey.updateRequestCode(generatedRequestCode);
    
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw MyCustomException("the user is not logged in!", "user-not-logged-in");
    }
    myRequestKey.updateGroupUUID(currentUser.uid);
    
    await ref.set(myRequestKey.toMap());
  }

  void removeRequestFromSession(String requestUUID) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("requestKeys").doc(requestUUID);

    await ref.delete();
  }

  void removeRequestWithCode(int requestCode) async {

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("requestKeys").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docsData = snapshot.docs;

    QueryDocumentSnapshot<Map<String, dynamic>> element =
        docsData.firstWhere((element) => element.get("requestCode") == requestCode);

    removeRequestFromSession(element.id);
  }

  Future<bool> isRequestCodeExists(int requestCode) async {

    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection("requestKeys").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docsData = snapshot.docs;
    return docsData.any((element) => element.get("requestCode") == requestCode);
  }

  Future<int> generateNotUsedRequestCode() async {

    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection("requestKeys").get();

    int requestCode;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> productsData = snapshot.docs.toList();

    do {

      requestCode = Random().nextInt(999999) + 100000;
    } while (productsData.any((element) => (element.get("requestCode") as int) == requestCode));

    return requestCode;
  }

  Future<MyRequestKey> getRequestKeyByCode(String requestCode) async {

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("requestKeys").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docsData = snapshot.docs;

    QueryDocumentSnapshot<Map<String, dynamic>> element =
    docsData.firstWhere((element) => element.get("requestCode") == requestCode);

    MyRequestKey requestKey = MyRequestKey.fromQuery(element);

    return requestKey;
  }

  /// [MyCustomException] Keys:
  ///- request-not-exists: the request code doesn't exist!
  Future<MyRequestGroup> getInfosAboutSession(int requestCode) async {

    bool existsRequest = await MyFirestoreService.requestService.isRequestCodeExists(requestCode);
    if (!existsRequest) {
      throw MyCustomException("the request code doesn't exist!",
          "request-not-exists");
    }

    MyRequestKey myRequestKey = await MyFirestoreService.requestService.getRequestKeyByCode(requestCode.toString());
    String groupUUID = myRequestKey.groupUUID;

    int sizeOfMembers = await MyFirestoreService.groupService.getSizeOfMembers(groupUUID);

    return MyRequestGroup(
    userOwnerUUID: myRequestKey.userOwnerUUID,
    sizeOfMembers: sizeOfMembers
    );
  }
}