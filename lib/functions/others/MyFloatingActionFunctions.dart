import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/functions/services/membersRequest/MyMembersRequestService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';

import '../services/firestore/MyFirestoreService.dart';

class MyFloatingActionFunctions {

  static void addGroup() {

    ///TODO: function

    /*try {

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
    }*/

    MyFirestoreService.requestService.addRequestForSession(MyRequestKey(userOwnerUUID: FirebaseAuth.instance.currentUser!.uid, requestCode: 000000));
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

    try {

      MyMembersRequestService myMembersRequestService = MyMembersRequestService();
      myMembersRequestService.addUserToGroupOverRequest("NVNIiFSCH8cEXnvOZTtvNWy8eo23", "h3tKwlXaRBkBflA8Mg9g", 275542);
    } on MyCustomException catch(e) {
      print(e.keyword);
    }

    ///TODO: function
  }
}