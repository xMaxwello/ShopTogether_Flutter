import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../objects/groups/MyGroup.dart';
import '../services/firestore/MyFirestoreService.dart';

class MyFunctions {

  static void addGroup() {

    ///TODO: function

    try {

      MyFirestoreService.groupService.addGroup(
          MyGroup(
              groupUUID: "",
              groupName: "Hallo",
              userUUIDs: [],
              products: []
          )
      );
    } on MyCustomException catch(e) {

      switch(e.keyword) {
        case "snapchot-not-exists":
          //print(e.message);
          break;
        case "error":
          print(e.message);
          break;
      }
    }
  }

  static void addProduct() async {
    ///TODO: function
    MyFirestoreService.productService.addProductToGroup(
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