import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/bottomSheetItems/MyItemBottomSheet.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';

import '../../functions/providers/floatingbutton/MyFloatingButtonProvider.dart';
import '../../functions/services/firestore/MyFirestoreService.dart';
import '../../objects/groups/MyGroup.dart';
import '../../objects/products/MyProduct.dart';
import '../../pages/MyProductPage.dart';
import '../bottomSheet/MyDraggableScrollableWidget.dart';
import '../group/MyGroupItem.dart';
import '../home/MyBasicStructItem.dart';
import '../product/MyProductItem.dart';

class MyDismissibleWidget extends StatelessWidget {

  final bool isGroup;
  final List<MyGroup> groupsFromUser;
  final List<MyProduct> productsFromSelectedGroup;
  final int itemIndex;
  final int selectedGroupIndex;
  final MyItemsProvider itemsValue;

  const MyDismissibleWidget({super.key, required this.isGroup, required this.groupsFromUser, required this.itemIndex, required this.selectedGroupIndex, required this.itemsValue, required this.productsFromSelectedGroup});

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      ///Defines the key for the Dismissible and uses the uuids of the objects
      key: isGroup ? Key(groupsFromUser[itemIndex].groupUUID!) : Key(productsFromSelectedGroup[itemIndex].productID!),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red[300],
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) async {

        ///remove group or product if the item is swiped
        if (isGroup) {

          ///TODO: Item wird nach löschen zuerst nicht angezeigt und dann doch, nach refreshen
          User? currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser != null) {

            String groupUUID = groupsFromUser[itemIndex].groupUUID!;

            if (await MyFirestoreService.groupService.isUserGroupOwner(groupUUID, currentUser.uid) == false) {

              MyDialog.showCustomDialog(
                  context: context,
                  title: "Wollen Sie die Gruppe wirklich verlassen?",
                  contentBuilder: (dialogContext) => [],
                  onConfirm: () async {

                    await MyFirestoreService.groupService.removeUserUUIDToGroup(groupUUID, currentUser.uid);
                    MyFirestoreService.userService.removeGroupUUIDsFromUser(currentUser.uid, groupUUID);

                    ///remove UserUUID of the products in this group, who should buy this product. (selectedUserUUID)
                    List<String?>? productUUIDs = await MyFirestoreService.productService.getProductUUIDsOfSelectedUser(groupUUID, currentUser.uid);
                    for (String? productUUID in productUUIDs!) {

                      MyFirestoreService.productService.updateSelectedUserOfProduct(groupUUID, productUUID!, "");
                    }
                  });
            } else {

              MyDialog.showCustomDialog(
                  context: context,
                  title: "Wollen Sie die Gruppe wirklich löschen?",
                  contentBuilder: (dialogContext) => [],
                  onConfirm: () async {

                    MyFirestoreService.groupService.removeGroup(groupsFromUser[itemIndex].groupUUID!);
              });
            }
          }
        } else {
          MyFirestoreService.productService.removeProductFromGroup(itemsValue.selectedGroupUUID, productsFromSelectedGroup[itemIndex].productID!);
        }
      },
      child: MyBasicStructItem(///the basic struct of the group, product, ... elements
        onTapFunction: () async {

          ///if the item is a group item, then it should open the product list
          ///if the item is a product item, it should shows the product bottom sheet
          if (isGroup) {

            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProductPage()));
          } else {

            String productUUID = productsFromSelectedGroup[itemIndex].productID!;
            MyProduct? myProduct = await MyFirestoreService.productService.getProductByUUID(groupsFromUser[selectedGroupIndex].groupUUID!, productUUID);

            if (myProduct != null) {
              String groupUUID = groupsFromUser[selectedGroupIndex].groupUUID!;
              List<Widget> bottomSheetWidgets = await MyItemBottomSheet.generateBottomSheet(
                  context,
                  myProduct.barcode,
                  fromProductList: true,
                  groupUUID: groupUUID,
              );
              showBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
                },
              );
            }
          }
          Provider.of<MyItemsProvider>(context, listen: false).updateItemIndex(isGroup ? groupsFromUser[itemIndex].groupUUID! : itemsValue.selectedGroupUUID);
          Provider.of<MyFloatingButtonProvider>(context, listen: false).updateExtended(true);
        },
        content:
        isGroup == true ?
        MyGroupItem(///shows the group at itemindex
            myGroup: groupsFromUser.elementAt(itemIndex)
        )
            :
        MyProductItem(///shows the product in group selectedGroupIndex at itemIndex
          myProduct: selectedGroupIndex != -1 ? productsFromSelectedGroup[itemIndex] : MyProduct(barcode: "", productID: "", productName: "", selectedUserUUID: "", productCount: 0, productVolumen: 0, productVolumenType: '', productImageUrl: ""),
          selectedGroupUUID: itemsValue.selectedGroupUUID,
        ),
      ),
    );
  }
}
