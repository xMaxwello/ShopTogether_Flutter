import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shopping_app/functions/String/MyStringHandler.dart';

class MySearchItem extends StatelessWidget {

  final Product product;

  const MySearchItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(
        MyStringHandler.truncateText((product.productName! != "" ? product.productName! :  "Unkown")
            + ": " +
            (product.servingSize.toString() != "null" ? product.servingSize.toString() : "/"), 35),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      leading: Icon(
        Icons.info,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
      trailing: IconButton(
          onPressed: () {

          },
          icon: Icon(
            Icons.add,
            size: Theme.of(context).iconTheme.size,
            color: Theme.of(context).iconTheme.color
          )
      ),
      onTap: () {

      },
    );
  }
}
