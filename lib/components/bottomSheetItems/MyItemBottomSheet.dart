import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';

class MyItemBottomSheet {

  static Future<List<Widget>> generateBottomSheet(BuildContext context, String barcode) async {
    MyOpenFoodFactsService service = MyOpenFoodFactsService();
    String placeholderBarcode = '5060337500401';

    Product? product = await service.getProductByBarcode(placeholderBarcode);
    if (product == null) {
      return [const Center(child: Text('Produkt nicht gefunden.'))];
    } else {

      //Produktname
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
      ];

      //Produktdetails
      productDetails.forEach((detail) {
        detail.forEach((key, value) {
          productInfoWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('$key: $value', style: Theme.of(context).textTheme.bodySmall),
              ),
            );
        });
        productInfoWidgets.add(const SizedBox(height: 10));
      });

      //Nutriscore
      String? nutriScore = product.nutriscore;
      if (nutriScore != null && nutriScore.isNotEmpty) {
        String nutriScoreAssetPath = 'assets/nutri_score/Nutri-score-$nutriScore.png';
        productInfoWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(nutriScoreAssetPath, height: 100),
          ),
        );
        productInfoWidgets.add(const SizedBox(height: 10));
      }

      //Zutatenangaben
      Map<String, String> ingredientsDetail = {'Zutaten': product.ingredientsText ?? 'Zutaten nicht verfügbar'};
      ingredientsDetail.forEach((key, value) {
        productInfoWidgets.add(
          Center(
            child: Text(
              key,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
        productInfoWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(value, style: Theme.of(context).textTheme.bodySmall),
          ),
        );
        productInfoWidgets.add(const SizedBox(height: 10));
      });


      String formatNutrientValue(double? value, String unit) {
        if (value == null) return 'N/A';
        return '${value.toStringAsFixed(1)} $unit';
      }

      List<Map<String, String>> nutritionData = [
        {'Energie': formatNutrientValue(product.nutriments?.getValue(Nutrient.energyKCal, PerSize.oneHundredGrams), 'kcal')},
        {'Fett': formatNutrientValue(product.nutriments?.getValue(Nutrient.fat, PerSize.oneHundredGrams), 'g')},
        {'Gesättigte Fettsäuren': formatNutrientValue(product.nutriments?.getValue(Nutrient.saturatedFat, PerSize.oneHundredGrams), 'g')},
        {'Kohlenhydrate': formatNutrientValue(product.nutriments?.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams), 'g')},
        {'Zucker': formatNutrientValue(product.nutriments?.getValue(Nutrient.sugars, PerSize.oneHundredGrams), 'g')},
        {'Eiweiß': formatNutrientValue(product.nutriments?.getValue(Nutrient.proteins, PerSize.oneHundredGrams), 'g')},
        {'Salz': formatNutrientValue(product.nutriments?.getValue(Nutrient.salt, PerSize.oneHundredGrams), 'g')},
      ];

      List<DataRow> nutritionRows = nutritionData.map((nutrition) {
        String key = nutrition.keys.first;
        String value = nutrition[key]!;
        return DataRow(cells: [
          DataCell(Text(key)),
          DataCell(Text(value)),
        ]);
      }).toList();

      //Nährwerttabelle
      productInfoWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nährwertangaben')),
                DataColumn(label: Text('Pro 100g')),
              ],
              rows: nutritionRows,
            ),
          ),
      );

      return productInfoWidgets;

    }
  }
}