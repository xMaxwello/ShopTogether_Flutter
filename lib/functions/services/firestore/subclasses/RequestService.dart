import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';

class RequestService {

  void addRequestForSession(MyRequestKey myRequestKey) async {

    DocumentReference<Map<String, dynamic>> ref =
    FirebaseFirestore.instance.collection("requestKeys").doc();

    int generatedRequestCode = await generateNotUsedRequestCode();

    myRequestKey.updateRequestCode(myRequestKey, generatedRequestCode);
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
}