import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_app/components/dismissible/MyDismissibleFunctions.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';

import '../../objects/groups/MyGroup.dart';
import '../../objects/products/MyProduct.dart';
import '../group/MyGroupItem.dart';
import '../home/MyBasicStructItem.dart';
import '../product/MyProductItem.dart';

/**
 * Its the widget item, which can you swipe to the side.
 * Its for the MyGroup and MyProduct items
 * */

class MyDismissibleWidget extends StatelessWidget {
  final bool isGroup;
  final List<MyGroup> groupsFromUser;
  final List<MyProduct> productsFromSelectedGroup;
  final int itemIndex;
  final int selectedGroupIndex;
  final MyItemsProvider itemsValue;

  const MyDismissibleWidget({
    Key? key,
    required this.isGroup,
    required this.groupsFromUser,
    required this.itemIndex,
    required this.selectedGroupIndex,
    required this.itemsValue,
    required this.productsFromSelectedGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: isGroup
          ? Key(groupsFromUser[itemIndex].groupUUID!)
          : Key(productsFromSelectedGroup[itemIndex].productID!),
      direction: DismissDirection.endToStart,
      background: buildDismissBackground(),
      confirmDismiss: (direction) async {

        MyDismissibleFuntions.onDismissedFunction(context, isGroup, groupsFromUser, itemIndex, itemsValue, productsFromSelectedGroup);
        return false;
      },
      child: buildMyBasicStructItem(context),
    );
  }

  Widget buildDismissBackground() {
    return Container(
      color: Colors.red[300],
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget buildMyBasicStructItem(BuildContext context) {
    return MyBasicStructItem(
      onTapFunction: () async {
        MyDismissibleFuntions.onTapFunction(
            context, isGroup, groupsFromUser, itemIndex, itemsValue, productsFromSelectedGroup, selectedGroupIndex);
      },
      content: buildItemContent(),
    );
  }

  Widget buildItemContent() {
    return isGroup
        ? MyGroupItem(myGroup: groupsFromUser.elementAt(itemIndex))
        : MyProductItem(
      myProduct: selectedGroupIndex != -1
          ? productsFromSelectedGroup[itemIndex]
          : MyProduct(
        barcode: "",
        productID: "",
        productName: "",
        selectedUserUUID: "",
        productCount: 0,
        productVolumen: "",
        productVolumenType: '',
        productImageUrl: "",
        productDescription: "",
      ),
      selectedGroupUUID: itemsValue.selectedGroupUUID,
    );
  }
}