import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../objects/groups/MyGroup.dart';
import '../firestore/MyFirestore.dart';

class MyFunctions {

  static void addGroup() {

    ///TODO: function

    MyFirestore.addGroup(
        MyGroup(
          groupUUID: "",
          groupName: "Hallo",
          userUUIDs: [],
          products: []
        )
    );
  }

  static void addProduct() async {
    ///TODO: function
    MyFirestore.addProduct(
      "",
      MyProduct(
          productID: "",
          productName: "Milch",
          selectedUserUUID: "fsdfsd",
          productCount: 3,
          productVolumen: 0,
          productVolumenType: '',
          productImageUrl: ""
      )
    );
  }

  static void addUserToGroup() {

    ///TODO: function
  }
}