import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/bottomSheet/MyDraggableScrollableWidget.dart';
import 'package:shopping_app/components/bottomSheetItems/MyItemBottomSheet.dart';
import 'package:shopping_app/functions/providers/search/MySearchProvider.dart';

import '../../functions/services/snackbars/MySnackBarService.dart';

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

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
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
  Widget build(BuildContext context) {
    Future<void> scan() async {
      final result = await BarcodeScanner.scan();

      if (result.type == ResultType.Barcode) {
        String currentUserUUID = FirebaseAuth.instance.currentUser?.uid ?? '';

        String groupUUID = ;

        List<Widget> bottomSheetWidgets = await MyItemBottomSheet.generateBottomSheet(
          context,
          result.rawContent,
          fromScanner: true,
          groupUUID: groupUUID,
          currentUserUUID: currentUserUUID,
        );

        showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return MyDraggableScrollableWidget(widgets: bottomSheetWidgets);
          },
        );
      } else if (result.type == ResultType.Cancelled) {
        MySnackBarService.showMySnackBar(context, "BarCodeScanner wurde verlassen!", isError: false);
      } else if (result.type == ResultType.Error) {
        MySnackBarService.showMySnackBar(context, "BarCode konnte nicht gescannt werden!");
      }
    }

    return Consumer<MySearchProvider>(
        builder: (BuildContext context, MySearchProvider mySearchProvider, Widget? child) {
          if (mySearchProvider.barcode != "") {
            controller.text = mySearchProvider.barcode;
          }

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

              )
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