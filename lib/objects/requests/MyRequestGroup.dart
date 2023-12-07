import 'package:flutter/cupertino.dart';

class MyRequestGroup extends ChangeNotifier {

  String userOwnerUUID;
  String groupUUID;
  int sizeOfMembers;

  MyRequestGroup({
    required this.userOwnerUUID,
    required this.groupUUID,
    required this.sizeOfMembers,
  });
}