import 'package:flutter/cupertino.dart';

class MyRequestGroup extends ChangeNotifier {

  String userOwnerUUID;
  int sizeOfMembers;

  MyRequestGroup({
    required this.userOwnerUUID,
    required this.sizeOfMembers,
  });
}