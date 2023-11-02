import 'package:flutter/foundation.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

class MyGroup extends ChangeNotifier {
  final String groupID;
  final String groupName;
  final List<String> userUUIDs;
  final List<MyProduct> products;

  MyGroup({
    required this.groupID,
    required this.groupName,
    required this.userUUIDs,
    required this.products,
  });
}
