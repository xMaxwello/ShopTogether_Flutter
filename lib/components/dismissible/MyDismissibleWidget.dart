import 'package:flutter/material.dart';
import 'package:shopping_app/components/dismissible/MyDismissibleFunctions.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';

import '../../objects/groups/MyGroup.dart';
import '../../objects/products/MyProduct.dart';
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

        MyDismissibleFuntions.onDismissedFunction(context, isGroup, groupsFromUser, itemIndex, itemsValue, productsFromSelectedGroup);
      },
      child: MyBasicStructItem(///the basic struct of the group, product, ... elements
        onTapFunction: () async {

          MyDismissibleFuntions.onTapFunction(context, isGroup, groupsFromUser, itemIndex, itemsValue, productsFromSelectedGroup, selectedGroupIndex);
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
