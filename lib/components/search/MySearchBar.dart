import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/product/MyProductAddItem.dart';
import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
import '../../functions/services/firestore/MyFirestoreService.dart';
import '../../functions/services/snackbars/MySnackBarService.dart';

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

          MyOpenFoodFactsService myOpenFoodFactsService = MyOpenFoodFactsService();


          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: StreamBuilder<SearchResult?>(
                stream: myOpenFoodFactsService.getProductByNameAsStream(['']),
                builder: (BuildContext context, AsyncSnapshot<SearchResult?> snapshot) {

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

                  return SearchAnchor(
                      headerTextStyle: Theme.of(context).textTheme.bodyMedium,
                      viewSurfaceTintColor: Theme.of(context).searchViewTheme.surfaceTintColor,
                      viewBackgroundColor: Theme.of(context).searchViewTheme.backgroundColor,
                      builder: (BuildContext context, SearchController controller) {

                        Future<void> scan() async {
                          final result = await BarcodeScanner.scan();

                          if (result.type == ResultType.Barcode) {

                            controller.text = result.rawContent;
                            controller.openView();
                          } else if (result.type == ResultType.Cancelled) {

                            MySnackBarService.showMySnackBar(context, "BarCodeScanner wurde verlassen!", isError: false);
                          } else if (result.type == ResultType.Error) {

                            MySnackBarService.showMySnackBar(context, "BarCode konnte nicht gescannt werden!");
                          }
                        }

                        return SearchBar(
                          surfaceTintColor: Theme.of(context).searchBarTheme.surfaceTintColor,
                          backgroundColor: Theme.of(context).searchBarTheme.backgroundColor,
                          textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall),
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
                              onPressed: () {
                                setState(() {
                                  scan();
                                });
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

                        //Provider.of<MyItemsProvider>(context, listen: false).updateSearchString(controller.text);
                        List<Product>? products = snapshot.data!.products;

                        return List<ListTile>.generate(products != null ? products.length : 0, (int index) {

                          print(products!.elementAt(index).productName);

                          MyProduct myProduct = MyProduct(
                              productID: products.elementAt(index).barcode!,
                              productName: products.elementAt(index).productName!,
                              selectedUserUUID: "",
                              productCount: 1,
                              productVolumen: 0,
                              productVolumenType: '',
                              productImageUrl: ""
                          );

                          return MyProductAddItem(
                            myProduct: myProduct,
                            addProductFunction: () async {

                              try {

                                if (await MyFirestoreService.groupService.isCurrentUserInGroup(itemsValue.selectedGroupUUID)) {

                                  MyFirestoreService.productService.addProductToGroup(itemsValue.selectedGroupUUID, myProduct);
                                  controller.closeView(myProduct.productID);
                                } else {

                                  MySnackBarService.showMySnackBar(context, "Sie haben keine Berechtigung dafür!");
                                }
                              } on MyCustomException catch(e) {

                                switch (e.keyword) {
                                  case "snapshot-not-exists":
                                    print(e.message);
                                    break;
                                  case "not-logged-in":
                                    print(e.message);
                                    break;
                                }
                              }
                            },
                            showProductInfoFunction: () async {
                              ///TODO: show Product info
                            },
                          );
                        });
                      }
                  );
                }
            ),
          );
        }
    );
  }
}