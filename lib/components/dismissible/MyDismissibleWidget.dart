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
  final List<String> groupUUIDs;
  final int itemIndex;
  final int selectedGroupIndex;
  final MyItemsProvider itemsValue;

  const MyDismissibleWidget({super.key, required this.isGroup, required this.groupsFromUser, required this.itemIndex, required this.selectedGroupIndex, required this.itemsValue, required this.groupUUIDs});

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: isGroup ? Key(groupsFromUser[itemIndex].groupUUID!) : Key(groupsFromUser[selectedGroupIndex].products[itemIndex].productID!),
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
          MyFirestoreService.productService.removeProductFromGroup(itemsValue.selectedGroupUUID, groupsFromUser[selectedGroupIndex].products[itemIndex].productID!);
        }
      },
      child: MyBasicStructItem(///the basic struct of the group, product, ... elements
        onTapFunction: () async {

          if (isGroup) {

            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProductPage()));
          } else {
            List<Widget> bottomSheetWidgets = await MyItemBottomSheet.generateBottomSheet(context, '5060337500401');
            //if (!mounted) return;
            showBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
              },
            );
          }
          Provider.of<MyItemsProvider>(context, listen: false).updateItemIndex(isGroup ? groupUUIDs[itemIndex] : itemsValue.selectedGroupUUID);
          Provider.of<MyFloatingButtonProvider>(context, listen: false).updateExtended(true);
        },
        content:
        isGroup == true ?
        MyGroupItem(///shows all groups of current user
            myGroup: groupsFromUser.elementAt(itemIndex)
        )
            :
        MyProductItem(///shows products of selected group from current user
          myProduct: selectedGroupIndex != -1 ? groupsFromUser.elementAt(selectedGroupIndex).products[itemIndex] : MyProduct(productID: "", productName: "", selectedUserUUID: "", productCount: 0, productVolumen: 0, productVolumenType: '', productImageUrl: ""),
          selectedGroupUUID: itemsValue.selectedGroupUUID,
        ),
      ),
    );
  }
}
