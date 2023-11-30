import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MyRequestKey extends ChangeNotifier {

  String userOwnerUUID;
  String groupUUID;
  int? requestCode;

  MyRequestKey({
    required this.userOwnerUUID,
    required this.groupUUID,
    this.requestCode,
  });

  void updateRequestCode(int requestCode) {
    this.requestCode = requestCode;
  }

  void updateGroupUUID(String groupUUID) {
    this.groupUUID = groupUUID;
  }

  void updateUserOwner(String userOwnerUUID) {
    this.userOwnerUUID = userOwnerUUID;
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
      groupUUID: map['groupUUID'] as String,
    );
  }

  factory MyRequestKey.fromQuery(QueryDocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return MyRequestKey(
      requestCode: data['requestCode'] as int,
      userOwnerUUID: data['userOwnerUUID'] as String,
      groupUUID: data['groupUUID'] as String,
    );
  }
}