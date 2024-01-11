import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/bottomSheet/MyDraggableScrollableWidget.dart';
import 'package:shopping_app/components/bottomSheetItems/MyCustomItemBottomSheet.dart';
import 'package:shopping_app/components/bottomSheetItems/MyGroupBottomSheet.dart';
import 'package:shopping_app/components/bottomSheetItems/MyMemberBottomSheet.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/ProductService.dart';
import 'package:shopping_app/functions/services/notification/MyNotificationService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';
import 'package:timezone/timezone.dart';

import '../services/firestore/MyFirestoreService.dart';

class MyFloatingActionFunctions {

  late BuildContext _context;
  late String _selectedGroupUUID;

  MyFloatingActionFunctions(BuildContext context, String selectedGroupUUID) {
    _context = context;
    _selectedGroupUUID = selectedGroupUUID;
  }

  void addGroup() async {

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
  }

  void addCustomProduct() async {
    String currentUserUUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    String newProductUUID = await ProductService().getUnusedProductUUID(_selectedGroupUUID);

    MyProduct newProduct = MyProduct(
      productID: newProductUUID,
      barcode: '',
      productName: 'Test',
      productCount: 1,
      productVolumen: '',
      productVolumenType: '',
      productImageUrl: '',
      selectedUserUUID: currentUserUUID,
      productDescription: 'lol'
    );

    ProductService().addProductToGroup(_selectedGroupUUID, newProduct);

    showModalBottomSheet(
      context: _context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MyDraggableScrollableWidget(
          widgets: [
            MyCustomItemBottomSheet(
              product: newProduct,
              productUUID: newProductUUID,
              groupUUID: _selectedGroupUUID,
            )
          ],
        );
      },
    );
  }

}
