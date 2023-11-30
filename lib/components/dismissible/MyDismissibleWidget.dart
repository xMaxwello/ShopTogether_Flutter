import 'package:flutter/material.dart';
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
      onDismissed: (direction) {

        ///TODO: User darf nur Gruppe löschen, wenn dieser der Owner ist

        ///TODO: Abfrage ob der User die Gruppe löschen möchte
        ///remove group or product if the item is swiped
        if (isGroup) {
          MyFirestoreService.groupService.removeGroup(groupsFromUser[itemIndex].groupUUID!);
        } else {
          MyFirestoreService.productService.removeProductFromGroup(itemsValue.selectedGroupUUID, groupsFromUser[selectedGroupIndex].products[itemIndex].productID!);
        }
      },
      child: child,
    );
  }
}
