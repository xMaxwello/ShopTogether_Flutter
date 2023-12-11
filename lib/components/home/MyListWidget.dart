import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openFood;
import 'package:shopping_app/functions/home/MySortHandler.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
import '../../functions/providers/search/MySearchProvider.dart';
import '../../objects/groups/MyGroup.dart';
import '../dismissible/MyDismissibleWidget.dart';
import '../search/MySearchItem.dart';

class MyListWidget extends StatelessWidget {

  final int itemLength;
  final ScrollController controller;
  final MySearchProvider mySearchProvider;
  final AsyncSnapshot<List<openFood.Product>>? searchSnapshot;
  final List<MyGroup> groupsFromUser;
  final MyItemsProvider itemsValue;
  final bool isSearch;
  final bool isGroup;
  final int selectedGroupIndex;

  const MyListWidget({super.key, required this.itemLength, required this.controller, required this.mySearchProvider, this.searchSnapshot, required this.groupsFromUser, required this.itemsValue, required this.isSearch, required this.isGroup, required this.selectedGroupIndex});

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    ///sort the products to the product names
    ///sort the products to the selected user, but the current users products are any time at the top
    List<MyProduct>? products = MySortHandler.getSortProductList(isGroup, user, groupsFromUser, selectedGroupIndex);

    List<String>? uniqueUserUUIDs = products?.map((product) => product.selectedUserUUID).toSet().toList();
    List<List<MyProduct>>? productsForUsers = MySortHandler.getProductsForUsers(products, uniqueUserUUIDs);
    int? uniqueUserLength = uniqueUserUUIDs?.length;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: !isGroup && !isSearch ? uniqueUserLength! : itemLength,
      controller: controller,
      itemBuilder: (context, index) {

        if (!isGroup && !isSearch) {

          List<MyProduct> userProducts = productsForUsers!.elementAt(index);
          return Column(
            children: [

              FutureBuilder<List<String>>(
                  future: MyFirestoreService.userService.getNameOfUser(uniqueUserUUIDs!.elementAt(index)),
                  builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Text("${snapshot.data!.elementAt(0)} ${snapshot.data!.elementAt(1)}");
                  }
              ),

              ListView.builder(
                  itemCount: userProducts.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int itemIndex) {

                    return MyDismissibleWidget( /// for the product and group views
                      isGroup: isGroup,
                      groupsFromUser: groupsFromUser,
                      itemIndex: itemIndex,
                      selectedGroupIndex: selectedGroupIndex,
                      itemsValue: itemsValue,
                      productsFromSelectedGroup: userProducts,
                    );
                  }),

            ],
          );
        }

        ///shows the items, dependent on the var isSearching and if the items should be a group or a product
        return SizedBox(
          child:  isSearch && !isGroup ?
          MySearchItem( ///for the search view
            currentUserUUID: user.uid,
            selectedGroupUUID: groupsFromUser.elementAt(selectedGroupIndex).groupUUID!,
            product: searchSnapshot!.data!.elementAt(index)
          )
            :
          MyDismissibleWidget( /// for the product and group views
            isGroup: isGroup,
            groupsFromUser: groupsFromUser,
            itemIndex: index,
            selectedGroupIndex: selectedGroupIndex,
            itemsValue: itemsValue,
            productsFromSelectedGroup: products ?? [],
          )
        );
      },
    );
  }
}