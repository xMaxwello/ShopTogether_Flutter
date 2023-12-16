import 'dart:async';

import 'package:flutter/material.dart';

import '../../functions/services/firestore/MyFirestoreService.dart';
import '../../functions/services/snackbars/MySnackBarService.dart';
import '../../objects/products/MyProduct.dart';

class MyUpdateProductAmountWidget extends StatefulWidget {

  final MyProduct myProduct;
  final String selectedGroupUUID;
  final int updateAmountAbout;
  final IconData icon;
  final bool isAddWidget;

  const MyUpdateProductAmountWidget({super.key, required this.myProduct, required this.selectedGroupUUID, required this.updateAmountAbout, required this.icon, required this.isAddWidget});

  @override
  State<MyUpdateProductAmountWidget> createState() => _MyUpdateProductAmountWidgetState();
}

class _MyUpdateProductAmountWidgetState extends State<MyUpdateProductAmountWidget> {

  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {

          ///the amount of the product shouldn`t be under 1
          if (widget.myProduct.productCount > 1 || widget.isAddWidget) {

            MyFirestoreService.productService.updateProductCountFromProduct(widget.selectedGroupUUID, widget.myProduct.productID!, widget.updateAmountAbout);
          } else {

            ///if amount of the product is 1 and the user want to reduce the amount this message will show up
            MySnackBarService.showMySnackBar(
              context,
              "Wollen Sie das Product löschen?",
              isFunctionAvailable: true,
              isError: false,
              actionLabel: "Löschen",
              actionFunction: () {

                MyFirestoreService.productService.removeProductFromGroup(widget.selectedGroupUUID, widget.myProduct.productID!);
              },
            );
          }
        },
        onLongPress: () {
          timer = Timer.periodic(
              const Duration(milliseconds: 100),
                  (timer) {

                if (widget.myProduct.productCount > 1) {

                  MyFirestoreService.productService.updateProductCountFromProduct(widget.selectedGroupUUID, widget.myProduct.productID!, widget.updateAmountAbout);
                }
              }
          );
        },
        onLongPressEnd: (_) {
          timer.cancel();
        },
        child: Icon(
          widget.icon,
          size: Theme.of(context).iconTheme.size,
          color: Theme.of(context).iconTheme.color,
        )
    );
  }
}