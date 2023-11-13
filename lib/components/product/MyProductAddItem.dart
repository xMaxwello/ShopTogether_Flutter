import 'package:flutter/material.dart';
import 'package:shopping_app/components/home/MyBasicStructItem.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

class MyProductAddItem extends ListTile {

  final MyProduct myProduct;
  final Function() addProductFunction;
  final Function() showProductInfoFunction;

  const MyProductAddItem({
    Key? key, required this.myProduct, required this.addProductFunction, required this.showProductInfoFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBasicStructItem(
      onTapFunction: showProductInfoFunction,
      content: Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: myProduct.productImageUrl.isNotEmpty
                      ? Image.network(
                    myProduct.productImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.error)),
                  )
                      : const Center(child: Icon(Icons.image, color: Colors.grey)),
                ),
                const SizedBox(width: 10),
                Text(
                  myProduct.productName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            GestureDetector(
              onTap: addProductFunction,
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).listTileTheme.tileColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Icon(
                      Icons.add,
                      size: Theme.of(context).iconTheme.size,
                      color: Theme.of(context).listTileTheme.iconColor,
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
