import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/bottomSheetItems/MyShowCustomItemBottomSheet.dart';

import '../../functions/dialog/MyDialog.dart';
import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import '../../functions/providers/items/MyItemsProvider.dart';
import '../../functions/services/firestore/MyFirestoreService.dart';
import '../../objects/groups/MyGroup.dart';
import '../../objects/products/MyProduct.dart';
import '../../pages/MyHomePage.dart';
import '../../pages/MyProductPage.dart';
import '../bottomSheet/MyDraggableScrollableWidget.dart';
import '../bottomSheetItems/MyItemBottomSheet.dart';

class MyDismissibleFuntions {

  static void onDismissedFunction (BuildContext context, bool isGroup, List<MyGroup> groupsFromUser, int itemIndex, MyItemsProvider itemsValue, List<MyProduct> productsFromSelectedGroup) async {

    ///remove group or product if the item is swiped
    if (isGroup) {

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {

        String groupUUID = groupsFromUser[itemIndex].groupUUID!;

        if (await MyFirestoreService.groupService.isUserGroupOwner(groupUUID, currentUser.uid) == false) {

          MyDialog.showCustomDialog(
              context: context,
              title: "Wollen Sie die Gruppe wirklich verlassen?",
              contentBuilder: (dialogContext) => [],
              onConfirm: () async {

                await MyFirestoreService.groupService.removeUserUUIDFromGroup(groupUUID, currentUser.uid);
                MyFirestoreService.userService.removeGroupUUIDsFromUser(currentUser.uid, groupUUID);

                ///remove UserUUID of the products in this group, who should buy this product. (selectedUserUUID)
                List<String?>? productUUIDs = await MyFirestoreService.productService.getProductUUIDsOfSelectedUser(groupUUID, currentUser.uid);
                for (String? productUUID in productUUIDs!) {

                  MyFirestoreService.productService.updateSelectedUserOfProduct(groupUUID, productUUID!, "");
                }
              },
              onCancelled: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
              }
          );
        } else {

          MyDialog.showCustomDialog(
              context: context,
              title: "Wollen Sie die Gruppe wirklich löschen?",
              contentBuilder: (dialogContext) => [],
              onConfirm: () async {

                MyFirestoreService.groupService.removeGroup(groupsFromUser[itemIndex].groupUUID!);
              },
              onCancelled: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
              }
          );
        }
      }
    } else {
      MyFirestoreService.productService.removeProductFromGroup(itemsValue.selectedGroupUUID, productsFromSelectedGroup[itemIndex].productID!);
    }
  }

  static void onTapFunction (BuildContext context, bool isGroup, List<MyGroup> groupsFromUser, int itemIndex, MyItemsProvider itemsValue, List<MyProduct> productsFromSelectedGroup, int selectedGroupIndex) async {

    ///if the item is a group item, then it should open the product list
    ///if the item is a product item, it should shows the product bottom sheet
    if (isGroup) {

      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProductPage()));
    } else {

      String productUUID = productsFromSelectedGroup[itemIndex].productID!;
      MyProduct? myProduct = await MyFirestoreService.productService.getProductByUUID(groupsFromUser[selectedGroupIndex].groupUUID!, productUUID);

      if (myProduct != null) {
        String groupUUID = groupsFromUser[selectedGroupIndex].groupUUID!;
        List<Widget> bottomSheetWidgets;

        if (myProduct.barcode.isNotEmpty) {
          bottomSheetWidgets = await MyItemBottomSheet.generateBottomSheet(
              context,
              myProduct.barcode,
              fromProductList: true,
              groupUUID: groupUUID,
              productUUID: productUUID
          );
        } else {
          bottomSheetWidgets = await MyShowCustomItemBottomSheet.generateBottomSheet(
              context,
              productUUID,
              groupUUID
          );
        }
        showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
          },
        );
      }
    }
    ///Updates the index of the clicked item, expands is the item a group or Product
    Provider.of<MyItemsProvider>(context, listen: false).updateItemIndex(isGroup ? groupsFromUser[itemIndex].groupUUID! : itemsValue.selectedGroupUUID);
    Provider.of<MyFloatingButtonProvider>(context, listen: false).updateExtended(true);
  }
}