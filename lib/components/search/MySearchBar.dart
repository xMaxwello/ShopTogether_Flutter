import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/bottomSheet/MyDraggableScrollableWidget.dart';
import 'package:shopping_app/components/bottomSheetItems/bottomSheetTest/MyBottomSheetTestItem.dart';
import 'package:shopping_app/components/product/MyProductAddItem.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
import '../../functions/services/firestore/MyFirestoreService.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {

  @override
  Widget build(BuildContext context) {
    return Consumer<MyItemsProvider>(
        builder: (BuildContext context,
            MyItemsProvider itemsValue,
            Widget? child) {

          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {

                  return SearchBar(
                    surfaceTintColor: Theme.of(context).searchBarTheme.surfaceTintColor,
                    controller: controller,
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: Icon(
                      Icons.search,
                      size: Theme.of(context).iconTheme.size,
                    ),
                    trailing: <Widget> [
                      IconButton(
                        onPressed: () async {
                          List<Widget> bottomSheetWidgets = await MyBottomSheetTestItem.generateBottomSheet(context, '5060337500401');
                          showBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
                              }
                          );
                        },
                        icon: Icon(
                          Icons.qr_code,
                          size: Theme.of(context).iconTheme.size,
                        ),
                      ),
                    ],
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                  );
                },
                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(10, (int index) {

                    MyProduct myProduct = MyProduct(
                        productID: "",
                        productName: "Schnitzel",
                        selectedUserUUID: "",
                        productCount: 1,
                        productVolumen: 0,
                        productVolumenType: '',
                        productImageUrl: ""
                    );

                    return MyProductAddItem(
                      myProduct: myProduct,
                      addProductFunction: () {

                        MyFirestoreService.addProduct(itemsValue.selectedGroupUUID, myProduct);
                        controller.closeView(myProduct.productID);
                      },
                      showProductInfoFunction: () {
                        ///TODO: show Product info
                        print("Product info");
                      },
                    );
                  });
                }
            ),
          );
        }
    );
  }
}