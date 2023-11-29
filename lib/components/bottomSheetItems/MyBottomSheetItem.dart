import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';

class MyBottomSheetItem {

  ///TODO: Nutriscore als Bild lokal abrufen? Da Bild nicht abrufbar über API
  ///TODO: Nährwertliste erstellen und Werte aus API einfügen
  ///TODO: Funktionen auslagern

  static Future<List<Widget>> generateBottomSheet(BuildContext context, String barcode) async {
    MyOpenFoodFactsService service = MyOpenFoodFactsService();
    String placeholderBarcode = '5060337500401';

    try {
      Product? product = await service.getProductByBarcode(placeholderBarcode);
      if (product == null) {
        return [const Center(child: Text('Produkt nicht gefunden.'))];
      }

      List<Widget> productInfoWidgets = [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  product.productName ?? 'Unbekannter Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              Image.network(product.imageFrontUrl ?? '', height: 200),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ];

      List<Map<String, String>> productDetails = [
        {'Barcode': product.barcode ?? ''},
        {'Marke': product.brands ?? ''},
        {'Menge': product.quantity ?? ''},
        {'Labels': product.labels ?? ''},
        {'Kategorie': product.categories ?? ''},
        {'Zutaten': product.ingredientsText ?? 'Zutaten nicht verfügbar'},
      ];

      productDetails.forEach((detail) {
        detail.forEach((key, value) {
          if (key == 'Zutaten') {
            productInfoWidgets.add(
              Center(
                child: Text(
                  key,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            );
            productInfoWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(value, style: Theme.of(context).textTheme.bodySmall),
              ),
            );
          } else {
            productInfoWidgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('$key: $value', style: Theme.of(context).textTheme.bodySmall),
              ),
            );
          }
        });
        productInfoWidgets.add(const SizedBox(height: 10));
      });

      return productInfoWidgets;

    } catch (e) {
      print(e);
      return [Center(
          child: Text(
          'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später erneut',
        style: Theme.of(context).textTheme.titleMedium,
      ))];
    }
  }
}

/*
DataTable nutritionTable = DataTable(
        columns: const [
          DataColumn(label: Text('Nährwertangaben')),
          DataColumn(label: Text('Pro 100g')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('Energie')),
            DataCell(Text('158 kj (37 kcal)')),
          ]),
          DataRow(cells: [
            DataCell(Text('Fett')),
            DataCell(Text('0 g')),
          ]),
          DataRow(cells: [
            DataCell(Text('Gesättigte Fettsäuren')),
            DataCell(Text('0 g')),
          ]),
          DataRow(cells: [
            DataCell(Text('Kohlenhydrate')),
            DataCell(Text('9,2 g')),
          ]),
          DataRow(cells: [
            DataCell(Text('Zucker')),
            DataCell(Text('9,2 g')),
          ]),
          DataRow(cells: [
            DataCell(Text('Eiweiß')),
            DataCell(Text('0 g')),
          ]),
          DataRow(cells: [
            DataCell(Text('Salz')),
            DataCell(Text('0,04 g')),
          ]),
        ],
      );
 */