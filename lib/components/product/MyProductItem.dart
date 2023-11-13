import 'package:flutter/material.dart';
import 'package:shopping_app/functions/snackbars/MySnackBar.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/firestore/MyFirestore.dart';

class MyProductItem extends StatelessWidget {

  final MyProduct myProduct;
  final String selectedGroupUUID;

  const MyProductItem({
    Key? key, required this.myProduct, required this.selectedGroupUUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: myProduct.productImageUrl.isNotEmpty ? Image.network(
                          myProduct.productImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                        ) : const Center(child: Icon(Icons.image, color: Colors.grey)),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          myProduct.productName, ///shows the product name
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                      ///TODO: Hier noch die Volumenangaben/Mengenangaben hinpacken, falls vorhanden: 2x Cola Dosen (=> 0,5l)

                      const SizedBox(width: 10),

                      // Stückzahl
                      IconButton(
                          onPressed: () {

                            ///the amount of the product shouldn`t be under 1
                            if (myProduct.productCount != 1) {

                              MyFirestore.updateProductCount(selectedGroupUUID, myProduct.productID, -1);
                            } else {

                              ///if amount of the product is 1 and the user want to reduce the amount this message will show up
                              MySnackBar.showMySnackBar(
                                context,
                                "Wollen Sie das Product löschen?",
                                isFunctionAvailable: true,
                                isError: false,
                                actionLabel: "Löschen",
                                actionFunction: () {

                                  MyFirestore.removeProduct(selectedGroupUUID, myProduct.productID);
                                },
                              );
                            }
                          },
                          icon: const Icon(Icons.remove)
                      ),
                      Text(
                        myProduct.productCount.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                          onPressed: () {

                            ///add amount to the product
                            MyFirestore.updateProductCount(selectedGroupUUID, myProduct.productID, 1);
                          },
                          icon: Icon(
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
        ),
      ],
    );
  }
}
