import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openFood;
import 'package:shopping_app/components/search/MySearchForMoreProductsWidget.dart';
import 'package:shopping_app/functions/home/MySortHandler.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
import '../../functions/providers/search/MySearchProvider.dart';
import '../../objects/groups/MyGroup.dart';
import '../dismissible/MyDismissibleWidget.dart';
import '../search/MySearchItem.dart';

/**
 * Its like a sub class of the MyHomeList. Because the class would become too big if not
 * */

class MyListWidget extends StatefulWidget {

  final int itemLength;
  final ScrollController controller;
  final MySearchProvider mySearchProvider;
  final AsyncSnapshot<List<openFood.Product>>? searchSnapshot;
  final List<MyGroup> groupsFromUser;
  final MyItemsProvider itemsValue;
  final bool isSearch;
  final bool isGroup;
  final int selectedGroupIndex;
  final String? searchedText;
  final int? maxSizeForSearch;

  const MyListWidget({super.key, required this.itemLength, required this.controller, required this.mySearchProvider, this.searchSnapshot, required this.groupsFromUser, required this.itemsValue, required this.isSearch, required this.isGroup, required this.selectedGroupIndex, this.searchedText, this.maxSizeForSearch});

  @override
  State<MyListWidget> createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {

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
    List<MyProduct>? products = MySortHandler.getSortProductList(widget.isGroup, user, widget.groupsFromUser, widget.selectedGroupIndex);

    List<String>? uniqueUserUUIDs = products?.map((product) => product.selectedUserUUID).toSet().toList();
    List<List<MyProduct>>? productsForUsers = MySortHandler.getProductsForUsers(products, uniqueUserUUIDs);
    int? uniqueUserLength = uniqueUserUUIDs?.length;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: !widget.isGroup && !widget.isSearch ? uniqueUserLength! : widget.itemLength,
      controller: widget.controller,
      itemBuilder: (context, index) {

        if (!widget.isGroup && !widget.isSearch) {

          List<MyProduct> userProducts = productsForUsers!.elementAt(index);
          return Column(
            children: [

              ///shows the name of the member who should buy these products
              FutureBuilder<List<String>>(
                  future: MyFirestoreService.userService.getNameOfUser(uniqueUserUUIDs!.elementAt(index)),
                  builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading...");
                    }

                    if (!snapshot.hasData) {
                      return const Text("Loading...");
                    }

                    return Text("${snapshot.data!.elementAt(0)} ${snapshot.data!.elementAt(1)}");
                  }
              ),

              ///shows the products of every single member
              ListView.builder(
                  itemCount: userProducts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int itemIndex) {

                    return MyDismissibleWidget( /// for the product and group views
                      isGroup: widget.isGroup,
                      groupsFromUser: widget.groupsFromUser,
                      itemIndex: itemIndex,
                      selectedGroupIndex: widget.selectedGroupIndex,
                      itemsValue: widget.itemsValue,
                      productsFromSelectedGroup: userProducts,
                    );
                  }),

            ],
          );
        }

        ///shows the items, dependent on the var isSearching and if the items should be a group or a product
        if (widget.isSearch && !widget.isGroup) {

          ///if no items returned of the search
          if (widget.itemLength < 2) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Center(
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Keine Suchergebnisse gefunden!"),
                      )
                  )
              ),
            );
          }

          ///if the maximum is reached of the search
          if (widget.maxSizeForSearch! <= widget.itemLength && index == widget.itemLength - 1) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Center(
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Keine weitere Suchergebnisse gefunden!"),
                      )
                  )
              ),
            );
          }

          ///Add a widget where the user add more Search Items
          if (index == widget.itemLength - 1) {

            return MySearchForMoreProductsWidget(
              itemLength: widget.itemLength,
            );
          }

          ///if no conditions applies, then show the SearchItem
          return MySearchItem( ///for the search view
            currentUserUUID: user.uid,
            selectedGroupUUID: widget.groupsFromUser.elementAt(widget.selectedGroupIndex).groupUUID!,
            product: widget.searchSnapshot!.data!.elementAt(index),
            searchedText: widget.searchedText!,
          );
        } else {

          return MyDismissibleWidget( /// for the product and group views
            isGroup: widget.isGroup,
            groupsFromUser: widget.groupsFromUser,
            itemIndex: index,
            selectedGroupIndex: widget.selectedGroupIndex,
            itemsValue: widget.itemsValue,
            productsFromSelectedGroup: products ?? [],
          );
        }
      },
    );
  }
}