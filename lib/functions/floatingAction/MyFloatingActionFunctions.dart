import 'package:flutter/material.dart';
import 'package:shopping_app/components/bottomSheet/MyDraggableScrollableWidget.dart';
import 'package:shopping_app/components/bottomSheetItems/MyGroupBottomSheet.dart';
import 'package:shopping_app/components/bottomSheetItems/MyMemberBottomSheet.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../services/firestore/MyFirestoreService.dart';

class MyFloatingActionFunctions {

  late BuildContext _context;
  late String _selectedGroupUUID;

  MyFloatingActionFunctions(BuildContext context, String selectedGroupUUID) {
    _context = context;
    _selectedGroupUUID = selectedGroupUUID;
  }

  void addGroup() {

    showModalBottomSheet(
      context: _context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MyDraggableScrollableWidget(
            widgets: MyGroupBottomSheet.generateBottomSheet(context)
        );
      },
    );

  }

  void addProduct() async {
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

  void addUserToGroup() {


    showModalBottomSheet(
      context: _context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MyDraggableScrollableWidget(
            widgets: MyMemberBottomSheet.generateBottomSheet(context, _selectedGroupUUID)
        );
      },
    );

    /*try {

      MyMembersRequestService myMembersRequestService = MyMembersRequestService();
      myMembersRequestService.addUserToGroupOverRequest("NVNIiFSCH8cEXnvOZTtvNWy8eo23", "h3tKwlXaRBkBflA8Mg9g", 275542);
    } on MyCustomException catch(e) {
      print(e.keyword);
    } */
  }
}