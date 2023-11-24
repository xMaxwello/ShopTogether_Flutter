import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';


class MyBottomSheetTestItem {
  static Future<List<Widget>> generateBottomSheet(BuildContext context, String barcode) async {
    MyOpenFoodFactsService service = MyOpenFoodFactsService();
    String placeholderBarcode = '5060337500401';

    try {
      Product? product = await service.getProductByBarcode(placeholderBarcode);
      if (product == null) {
        return [const Center(child: Text('Produkt nicht gefunden.'))];
      }
      String imageUrl = product.imageFrontUrl ?? '';
      String ingredients = product.ingredientsText ?? 'Zutaten nicht verfügbar';
      String barcode = product.barcode ?? '';
      String brand = product.brands ?? '';
      String quantity = product.quantity ?? '';
      String labels = product.labels ?? '';
      String category = product.categories ?? '';
      String nutriScore = product.nutriscore ?? ''; ///TODO: Nutriscore als Bild lokal abrufen? Da Bild nicht abrufbar über API


      ///TODO: Nährwertliste erstellen und Werte aus API einfügen


      return [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  product.productName ?? 'Unbekannter Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              Image.network(imageUrl, height: 200),
              const SizedBox(height: 20),
              Text('Barcode: $barcode',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text('Marke: $brand',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text('Menge: $quantity',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text('Labels: $labels',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text('Kategorie: $category',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text('Zutaten',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 10),
              Text(ingredients,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ];
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