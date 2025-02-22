import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/bottomSheetItems/MyCustomItemBottomSheet.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';

import '../../functions/dialog/MyDialog.dart';
import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import '../../functions/providers/items/MyItemsProvider.dart';
import '../../functions/services/firestore/MyFirestoreService.dart';
import '../../objects/groups/MyGroup.dart';
import '../../objects/products/MyProduct.dart';
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
                await MyFirestoreService.userService.removeGroupUUIDsFromUser(currentUser.uid, groupUUID);

                List<String> userUUIDs = await MyFirestoreService.groupService.getMemberUUIDsAsList(groupUUID);

                await MyFirestoreService.productService.updateSelectedUserOfProducts(groupUUID, currentUser.uid, userUUIDs[0]);
                MySnackBarService.showMySnackBar(context, "Sie haben die Gruppe verlassen!", isError: false);
              },
          );
        } else {

          MyDialog.showCustomDialog(
              context: context,
              title: "Wollen Sie die Gruppe wirklich löschen?",
              contentBuilder: (dialogContext) => [],
              onConfirm: () async {

                MyFirestoreService.groupService.removeGroup(groupsFromUser[itemIndex].groupUUID!);
                MySnackBarService.showMySnackBar(context, "Sie haben die Gruppe gelöscht!", isError: false);
              },
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

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyProductPage()));
    } else {

      String productUUID = productsFromSelectedGroup[itemIndex].productID!;
      MyProduct? myProduct = await MyFirestoreService.productService.getProductByUUID(groupsFromUser[selectedGroupIndex].groupUUID!, productUUID);

      if (myProduct != null) {
        String groupUUID = groupsFromUser[selectedGroupIndex].groupUUID!;

        if (myProduct.barcode.isNotEmpty) {
          List<Widget> bottomSheetWidgets = await MyItemBottomSheet.generateBottomSheet(
              context,
              myProduct.barcode,
              fromProductList: true,
              groupUUID: groupUUID,
              productUUID: productUUID
          );
          showBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
            },
          );
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return MyDraggableScrollableWidget(
                widgets: [
                  MyCustomItemBottomSheet(
                    productUUID: productUUID,
                    groupUUID: groupUUID,
                    isNewProduct: false,
                  )
                ],
              );
            },
          );
        }
      }
    }
    ///Updates the index of the clicked item, expands is the item a group or Product
    Provider.of<MyItemsProvider>(context, listen: false).updateItemIndex(isGroup ? groupsFromUser[itemIndex].groupUUID! : itemsValue.selectedGroupUUID);
    Provider.of<MyFloatingButtonProvider>(context, listen: false).updateExtended(true);
  }
}