import 'package:flutter/foundation.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';
import 'package:shopping_app/objects/users/MyUsers.dart';

class MyGroup extends ChangeNotifier {
  final String groupID;
  final String groupName;
  final List<MyUser> users;
  final List<MyProduct> shoppingList;

  MyGroup({
    required this.groupID,
    required this.groupName,
    required this.users,
    required this.shoppingList,
  });
}
