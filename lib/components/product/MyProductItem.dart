import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/services/firestore/MyFirestoreService.dart';

class MyProductItem extends StatefulWidget {

  final MyProduct myProduct;
  final String selectedGroupUUID;

  const MyProductItem({Key? key, required this.myProduct, required this.selectedGroupUUID}) : super(key: key);

  @override
  State<MyProductItem> createState() => _MyProductItemState();
}

class _MyProductItemState extends State<MyProductItem> {

  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 6, right: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: widget.myProduct.productImageUrl.isNotEmpty ? Image.network(
                      widget.myProduct.productImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                    ) : const Center(child: Icon(Icons.image, color: Colors.grey)),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Text(
                            widget.myProduct.productName, ///shows the product name
                            style: Theme.of(context).textTheme.titleSmall,
                          ),

                          widget.myProduct.productVolumen == 0 && widget.myProduct.productVolumenType == "" ?
                          const SizedBox()
                              :
                          Text( /// shows product volumen
                            widget.myProduct.productVolumen.toString() + widget.myProduct.productVolumenType,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),

                        ],
                      )
                  ),

                  const SizedBox(width: 10),

                  GestureDetector(
                      onTap: () {

                        ///the amount of the product shouldn`t be under 1
                        if (widget.myProduct.productCount > 1) {

                          MyFirestoreService.productService.updateProductCountFromProduct(widget.selectedGroupUUID, widget.myProduct.productID!, -1);
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
                        _timer = Timer.periodic(
                            const Duration(milliseconds: 100),
                                (timer) {

                              if (widget.myProduct.productCount > 1) {

                                MyFirestoreService.productService.updateProductCountFromProduct(widget.selectedGroupUUID, widget.myProduct.productID!, -1);
                              }
                            }
                        );
                      },
                      onLongPressEnd: (_) {
                        _timer.cancel();
                      },
                      child: const Icon(Icons.remove)
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    widget.myProduct.productCount.toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                      onTap: () {

                        ///add amount to the product
                        MyFirestoreService.productService.updateProductCountFromProduct(widget.selectedGroupUUID, widget.myProduct.productID!, 1);
                      },
                      onLongPress: () {
                        _timer = Timer.periodic(
                            const Duration(milliseconds: 100),
                                (timer) {
                              MyFirestoreService.productService.updateProductCountFromProduct(widget.selectedGroupUUID, widget.myProduct.productID!, 1);
                            }
                        );
                      },
                      onLongPressEnd: (_) {
                        _timer.cancel();
                      },
                      child: Icon(
                        Icons.add,
                        size: Theme.of(context).iconTheme.size,
                        color: Theme.of(context).iconTheme.color,
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4,),
          ],
        )
    );
  }
}