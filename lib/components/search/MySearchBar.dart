import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/product/MyProductAddItem.dart';
import 'package:shopping_app/functions/firestore/MyFirestore.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/providers/items/MyItemsProvider.dart';

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
                    surfaceTintColor: MaterialStateProperty.all(
                        Color.lerp(Colors.white, Theme
                            .of(context)
                            .colorScheme
                            .primary, 0.8)),
                    controller: controller,
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                    trailing: <Widget> [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            ///TODO: add function
                          });
                        },
                        icon: const Icon(Icons.qr_code),
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
                        productImageUrl: ""
                    );

                    return ListTile(
                      title: MyProductAddItem(
                          myProduct: myProduct
                      ),
                      onTap: () {
                        MyFirestore.addProduct(itemsValue.selectedGroupUUID, myProduct);
                        controller.closeView(myProduct.productID);
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