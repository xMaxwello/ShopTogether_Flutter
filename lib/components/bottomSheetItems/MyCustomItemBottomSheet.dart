import 'package:flutter/material.dart';

class MyCustomItemBottomSheet {

  static Future<List<Widget>> generateBottomSheet(
      BuildContext context, {
        required String productName,
        required Map<String, String> productDetails
      }) async {

    // Produktname
    List<Widget> productInfoWidgets = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Text(
                productName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ];

    // Produktdetails
    productDetails.forEach((key, value) {
      productInfoWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('$key: $value', style: Theme.of(context).textTheme.bodySmall),
        ),
      );
      productInfoWidgets.add(const SizedBox(height: 10));
    });

    return productInfoWidgets;
  }
}