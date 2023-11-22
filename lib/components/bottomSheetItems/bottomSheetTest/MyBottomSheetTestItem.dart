import 'package:flutter/material.dart';

class MyBottomSheetTestItem {
  static List<Widget> generateBottomSheet(BuildContext context) {

    String productName = "Paulaner Spezi";
    String barcode = "4066600603405";
    String quantity = "0.5l";
    String imageUrl = "https://images.openfoodfacts.org/images/products/406/660/060/3405/front_de.73.full.jpg";
    String packaging = "Bottle";
    String brands = "Paulaner";
    String labels = "Vegetarian, No gluten, Vegan";
    String ingredients = "water, sugar, orange juice from orange juice concentrate (2.2%), lemon juice from lemon juice concentrate (0.8%), carbonic acid, orange extract, dye e 150d, acidifier phosphoric acid and citric acid, acidity regulator sodium citrate, natural flavor, flavor caffeine, antioxidant ascorbic acid, stabilizer locust bean gum";

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


    return <Widget> [

      const SizedBox(
        height: 40,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              children: <Widget>[

                Center(
                  child: Text(productName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

            const SizedBox(height: 10),

            Image.network(imageUrl, height: 200),

            const SizedBox(height: 10),

            Text('Barcode: $barcode',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text('Menge: $quantity',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text('Verpackung: $packaging',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text('Marke: $brands',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text('Labels: $labels',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 30),

            Center(
              child: Text("Zutaten",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            Text(ingredients,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 30),

            Center(
              child: Text("Nährwerte",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            const SizedBox(height: 10),

            nutritionTable,

              ]
          )
      )
    ];
  }
}