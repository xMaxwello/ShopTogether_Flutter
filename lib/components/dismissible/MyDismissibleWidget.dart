import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';

import '../../functions/services/firestore/MyFirestoreService.dart';
import '../../objects/groups/MyGroup.dart';

class MyDismissibleWidget extends StatelessWidget {

  final bool isGroup;
  final List<MyGroup> groupsFromUser;
  final int itemIndex;
  final int selectedGroupIndex;
  final Widget child;
  final MyItemsProvider itemsValue;

  const MyDismissibleWidget({super.key, required this.isGroup, required this.groupsFromUser, required this.itemIndex, required this.selectedGroupIndex, required this.child, required this.itemsValue});

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
      child: child,
    );
  }
}
