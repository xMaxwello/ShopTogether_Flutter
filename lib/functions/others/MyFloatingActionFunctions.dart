import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../objects/groups/MyGroup.dart';
import '../services/firestore/MyFirestoreService.dart';

class MyFloatingActionFunctions {

  static void addGroup() {

    ///TODO: function

    MyFirestoreService.addGroup(
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
    MyFirestoreService.addProduct(
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