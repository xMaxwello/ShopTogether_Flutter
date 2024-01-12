import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/bottomSheetItems/MyItemBottomSheet.dart';
import 'package:shopping_app/functions/String/MyStringHandler.dart';
import 'package:shopping_app/functions/providers/search/MySearchProvider.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../bottomSheet/MyDraggableScrollableWidget.dart';

/**
 * This widget shows a product and the infos of it.
 * This widget show up, when you search for products
 * */
class MySearchItem extends StatelessWidget {

  final String currentUserUUID;
  final String selectedGroupUUID;
  final Product product;
  final String searchedText;

  const MySearchItem({super.key, required this.product, required this.selectedGroupUUID, required this.currentUserUUID, required this.searchedText});

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(
        MyStringHandler.truncateText("${product.productName != "" && product.productName != null ? product.productName! :  "Unkown"}: ${product.quantity.toString() != "null" ? product.quantity.toString() : "/"}", 35),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      leading: Icon(
        Icons.info,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      trailing: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();

            Provider.of<MySearchProvider>(context, listen: false).updateIsSearching(false);

            MyFirestoreService.productService.addProductToGroup(
              selectedGroupUUID,
              MyProduct(
                barcode: product.barcode!,

                productName: (product.productName != "" && product.productName != null ?
                product.productName! :
                (searchedText != "" ? searchedText :
                (product.brands != null ? product.brands! : "Unkown"))
                ),

                selectedUserUUID: currentUserUUID,
                productCount: 1,
                productVolumen: product.quantity != null ? product.quantity! : "",
                productVolumenType: '',
                productImageUrl: product.imageFrontUrl ?? '',
                productDescription: ''
              )
            );
          },
          icon: Icon(
            Icons.add,
            size: Theme.of(context).iconTheme.size,
            color: Theme.of(context).iconTheme.color
          )
      ),
      onTap: () async {

        List<Widget> bottomSheetWidgets = await MyItemBottomSheet.generateBottomSheet(context, product.barcode!);
        showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            FocusScope.of(context).unfocus();
            return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
          },
        );
      },
    );
  }
}