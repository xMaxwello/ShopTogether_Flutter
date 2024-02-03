import 'package:flutter/material.dart';
import 'package:shopping_app/components/product/MyUpdateProductAmountWidget.dart';
import 'package:shopping_app/functions/string/MyStringHandler.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

/**
 * its shows the product with there infos
 * */
class MyProductItem extends StatefulWidget {

  final MyProduct myProduct;
  final String selectedGroupUUID;

  const MyProductItem({Key? key, required this.myProduct, required this.selectedGroupUUID}) : super(key: key);

  @override
  State<MyProductItem> createState() => _MyProductItemState();
}

class _MyProductItemState extends State<MyProductItem> {

  int counter = 0;

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

                  ///the image of the product
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: widget.myProduct.productImageUrl.isNotEmpty ? Image.network(
                        widget.myProduct.productImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                      ) : const Center(child: Icon(Icons.image, color: Colors.grey)),
                    )
                  ),

                  const SizedBox(width: 10),

                  ///infos about the product
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Text(
                            MyStringHandler.truncateText(widget.myProduct.productName, 35), ///shows the product name
                            style: Theme.of(context).textTheme.titleSmall,
                          ),

                          widget.myProduct.productVolumen == "" && widget.myProduct.productVolumenType == "" ?
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

                  ///with the MyUpdateProductAmountWidget can the user change the amount of the Product
                  MyUpdateProductAmountWidget(myProduct: widget.myProduct, selectedGroupUUID: widget.selectedGroupUUID, updateAmountAbout: -1, icon: Icons.remove, isAddWidget: false,
                    onUpdateCounter: (int newCounter) {
                      setState(() {
                        counter = newCounter;
                      });
                    }, ),
                  const SizedBox(width: 5,),
                  Text(
                    counter == 0 ? widget.myProduct.productCount.toString() : (widget.myProduct.productCount + counter).toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 5,),
                  MyUpdateProductAmountWidget(myProduct: widget.myProduct, selectedGroupUUID: widget.selectedGroupUUID, updateAmountAbout: 1, icon: Icons.add, isAddWidget: true,
                    onUpdateCounter: (int newCounter) {
                      setState(() {
                        counter = newCounter;
                      });
                    }, ),
                ],
              ),
            ),
            const SizedBox(height: 4,),
          ],
        )
    );
  }
}