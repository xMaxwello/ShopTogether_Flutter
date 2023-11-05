import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';

import '../../objects/users/MyUsers.dart';

class MyFirestore {

  static void addUser(MyUser myUser) {

  }

  static void removeUser(MyUser myUser) {

  }

  static void addGroup(MyGroup myGroup) {
    FirebaseFirestore.instance.collection("groups").doc().set(myGroup.toMap());
  }

}