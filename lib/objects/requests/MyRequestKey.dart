import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyRequestKey extends ChangeNotifier {

  String userOwnerUUID;
  int requestCode;

  MyRequestKey({
    required this.userOwnerUUID,
    required this.requestCode,
  });

  void updateRequestCode(MyRequestKey requestKey, int requestCode) {
    requestKey.requestCode = requestCode;
  }

  void updateUserOwner(MyRequestKey requestKey, String userOwnerUUID) {
    requestKey.userOwnerUUID = userOwnerUUID;
  }

  Map<String, dynamic> toMap() {
    return {
      'requestCode': requestCode,
      'userOwnerUUID': userOwnerUUID,
    };
  }

  factory MyRequestKey.fromMap(Map<String, dynamic> map) {
    return MyRequestKey(
      requestCode: map['requestCode'] as int,
      userOwnerUUID: map['userOwnerUUID'] as String,
    );
  }

  factory MyRequestKey.fromQuery(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return MyRequestKey(
      requestCode: data['requestCode'] as int,
      userOwnerUUID: data['userOwnerUUID'] as String,
    );
  }
}