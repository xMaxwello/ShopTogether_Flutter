import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/providers/search/MySearchProvider.dart';

class MySearchForMoreProductsWidget extends StatelessWidget {

  final int itemLength;

  const MySearchForMoreProductsWidget({super.key, required this.itemLength});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Center(
        child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey.shade100)
            ),
            onPressed: () {

              Provider.of<MySearchProvider>(context, listen: false).updateSizeOfSearchedProducts(itemLength + 20);
            },
            child: Text(
              "20 weitere Produkte anzeigen!",
              style: Theme.of(context).textTheme.displayMedium,
            )
        ),
      ),
    );
  }
}