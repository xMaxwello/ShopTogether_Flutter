import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/search/searchBar/MySearchBarFunctions.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';
import 'package:shopping_app/functions/providers/search/MySearchProvider.dart';

/**
 * With this widget, the user can search for products
 * */
class MySearchBar extends StatefulWidget {

  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool _isSearchActive = false;
  bool _isKeyboardVisible() {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }

  void _resetSearchState() {
    _isSearchActive = false;
    Provider.of<MySearchProvider>(context, listen: false).updateIsSearching(false);
    controller.clear();
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      _isSearchActive = true;
      Provider.of<MySearchProvider>(context, listen: false).updateIsSearching(true);
    } else if (!_isSearchActive) {
      Provider.of<MySearchProvider>(context, listen: false).updateIsSearching(false);
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MySearchProvider>(
        builder: (BuildContext context, MySearchProvider mySearchProvider, Widget? child) {

          if (mySearchProvider.barcode != "") {
            controller.text = mySearchProvider.barcode;
          }

          return Consumer<MyItemsProvider>(
              builder: (BuildContext context, MyItemsProvider myItemsProvider, Widget? child) {

                return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                    child: SearchBar(
                      controller: controller,
                      focusNode: focusNode,
                      surfaceTintColor: Theme.of(context).searchBarTheme.surfaceTintColor,
                      backgroundColor: Theme.of(context).searchBarTheme.backgroundColor,
                      hintStyle: MaterialStateProperty.all(Theme.of(context).textTheme.labelMedium),
                      hintText: 'Nach Produkt suchen...',
                      textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.bodyMedium),
                      onChanged: (String changedText) {
                        Provider.of<MySearchProvider>(context, listen: false).updateSearchedText(changedText);
                        Provider.of<MySearchProvider>(context, listen: false).updateIsSearching(true);
                      },
                      onSubmitted: (String endText) {
                        Provider.of<MySearchProvider>(context, listen: false).updateSearchedText(endText);
                        controller.clear();
                      },
                      leading: Row(
                          children: [
                            mySearchProvider.isSearching ?
                            IconButton(
                                onPressed: () {
                                  if (!_isKeyboardVisible() && _isSearchActive) {
                                    _resetSearchState();
                                  }
                                  if (_isKeyboardVisible()) {
                                    _resetSearchState();
                                    focusNode.unfocus();
                                  }
                                  _isSearchActive = false;
                                  focusNode.unfocus();
                                  controller.clear();
                                  Provider.of<MySearchProvider>(context, listen: false).updateSizeOfSearchedProducts(45);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: Theme.of(context).iconTheme.size,
                                  color: Theme.of(context).iconTheme.color,
                                )
                            ) : const SizedBox(),
                            Icon(
                              Icons.search,
                              size: Theme.of(context).iconTheme.size,
                            )
                          ]
                      ),
                      trailing: <Widget> [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              MySearchBarFunctions.scan(context, myItemsProvider.selectedGroupUUID);
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

                    )
                );
              }
          );
        }
    );
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }
}