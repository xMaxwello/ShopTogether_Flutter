import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
import '../../functions/providers/search/MySearchProvider.dart';
import '../../objects/groups/MyGroup.dart';
import '../dismissible/MyDismissibleWidget.dart';
import '../search/MySearchItem.dart';

class MyListWidget extends StatelessWidget {

  final int itemLength;
  final ScrollController controller;
  final MySearchProvider mySearchProvider;
  final AsyncSnapshot<List<Product>>? searchSnapshot;
  final List<MyGroup> groupsFromUser;
  final MyItemsProvider itemsValue;
  final List<String> groupUUIDs;
  final bool isSearch;
  final bool isGroup;
  final int selectedGroupIndex;

  const MyListWidget({super.key, required this.itemLength, required this.controller, required this.mySearchProvider, this.searchSnapshot, required this.groupsFromUser, required this.itemsValue, required this.groupUUIDs, required this.isSearch, required this.isGroup, required this.selectedGroupIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemLength,
      controller: controller,
      itemBuilder: (context, index) {

        return SizedBox(
          child: isSearch && !isGroup ?
          MySearchItem(s: searchSnapshot!.data!.elementAt(index).productName ?? "Unknow")
              :
          MyDismissibleWidget(
            isGroup: isGroup,
            groupsFromUser: groupsFromUser,
            itemIndex: index,
            selectedGroupIndex: selectedGroupIndex,
            itemsValue: itemsValue,
            groupUUIDs: groupUUIDs,
          ),
        );
      },
    );
  }
}