import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
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

          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: SearchAnchor(
                viewLeading: Row(
                  children: [

                    IconButton(
                        onPressed: () {
                          SearchController controller = SearchController();
                          controller.closeView("");
                        },
                        icon: const Icon(Icons.arrow_left)
                    ),

                    IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.search)
                    ),

                  ],
                ),
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
                suggestionsBuilder: (BuildContext context, SearchController controller) async {

                  SearchResult? searchResult = await MyOpenFoodFactsService().getProductByName([controller.text]);

                  return List.generate(searchResult != null && searchResult.products != null ? searchResult.products!.length : 1, (index) {

                    if (searchResult!.products!.isEmpty) {
                      return const Center(
                        child: Text('No Products'),
                      );
                    }

                    return ListTile(
                      title: Text(searchResult.products![index].productName ?? 'Unknown Product', style: Theme.of(context).textTheme.bodyMedium,),
                      onTap: () {

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