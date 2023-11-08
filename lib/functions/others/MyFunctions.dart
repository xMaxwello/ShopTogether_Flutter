import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../objects/groups/MyGroup.dart';
import '../firestore/MyFirestore.dart';

class MyFunctions {

  static void addGroup() {

    MyFirestore.addGroup(
        MyGroup(
          groupUUID: "",
          groupName: "Hallo",
          userUUIDs: [],
          products: []
        )
    );
  }

  static void addProduct() {

    MyFirestore.addProduct(
      "",
      MyProduct(
          productID: "",
          productName: "Milch",
          selectedUserUUID: "fsdfsd",
          productCount: 3,
          productImageUrl: ""
      )
    );
  }

  static void addUserToGroup() {


  }
}