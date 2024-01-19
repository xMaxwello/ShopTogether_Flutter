import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shopping_app/functions/services/openfoodfacts/MyOpenFoodFactsService.dart';
import 'package:shopping_app/objects/products/MyProduct.dart';

import '../../functions/services/firestore/MyFirestoreService.dart';
import '../../objects/users/MyUsers.dart';

class MyItemBottomSheet {

  static Future<List<Widget>> generateBottomSheet(
      BuildContext context,
      String barcode,
      {
        bool fromProductList = false,
        String? groupUUID,
        bool fromScanner = false,
        String? currentUserUUID,
        String? productUUID
      }) async {
    MyOpenFoodFactsService service = MyOpenFoodFactsService();
    Product? product = await service.getProductByBarcode(barcode);

    if (product == null) {
      return [const Padding(
        padding: EdgeInsets.only(bottom: 20, top: 240),
        child: Center(
            child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Produkt wurde nicht gefunden!"),
                )
            )
        ),
      )];
    }

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
            if (product.imageFrontUrl != null && Uri.parse(product.imageFrontUrl!).isAbsolute)
              Image.network(product.imageFrontUrl!, height: 200)
            else
              const Text(
                  'Bild nicht verfügbar'
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ];

    //Button für BottomSheet nach Scan
    if (fromScanner && groupUUID != null && currentUserUUID != null) {
      productInfoWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () async {
              MyProduct newProduct = MyProduct(
                  barcode: barcode,
                  productName: product.productName ?? "Unbekannt",
                  selectedUserUUID: currentUserUUID,
                  productCount: 1,
                  productVolumen: "0",
                  productVolumenType: '',
                  productImageUrl: product.imageFrontUrl ?? '',
                  productDescription: ''
              );

              MyFirestoreService.productService.addProductToGroup(groupUUID, newProduct);
              Navigator.pop(context);
            },
            child: Text('Produkt hinzufügen',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
      );
      productInfoWidgets.add(const SizedBox(height: 20));
    }

    //Zuweisung Mitglied
    if (fromProductList && groupUUID != null) {
      Stream<List<MyUser>> userStream = await MyFirestoreService.groupService.getMembersAsStream(groupUUID);
      productInfoWidgets.add(
        StreamBuilder<List<MyUser>>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Keine Mitglieder gefunden');
            }
            List<MyUser> users = snapshot.data!;

            if (users.length > 1) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FutureBuilder<MyProduct?>(
                      future: MyFirestoreService.productService.getProductByUUID(groupUUID, productUUID!),
                      builder: (BuildContext context,
                          AsyncSnapshot<MyProduct?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Käufer zuweisen:',
                                    style: Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  DropdownButton<String>(
                                    hint: Text('Mitglied auswählen',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    items: users.map((MyUser user) {
                                      return DropdownMenuItem<String>(
                                        value: user.uuid,
                                        child: Center(
                                          child: Text('${user.prename} ${user.surname}',
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (
                                        String? selectedUserUUID) async {
                                      if (selectedUserUUID != null) {
                                        MyFirestoreService.productService.updateSelectedUserOfProduct(
                                            groupUUID, productUUID, selectedUserUUID);
                                      }
                                    },
                                    value: snapshot.data?.selectedUserUUID,
                                  ),
                                ]
                            ),
                          ),
                        );
                      }
                  )
              );
            }
            else {
              return Container();
            }
          }
        ),
      );
      productInfoWidgets.add(const SizedBox(height: 20));
    }

    List<Map<String, String>> productDetails = [
      {'Barcode': product.barcode ?? 'N/A'},
      {'Marke': product.brands ?? 'N/A'},
      {'Menge': product.quantity ?? 'N/A'},
      {'Labels': product.labels ?? 'N/A'},
      {'Kategorie': product.categories ?? 'N/A'},
      {'Geschäft': product.stores ?? 'N/A'},
    ];

    //Produktdetails
    for (var detail in productDetails) {
      detail.forEach((key, value) {
        productInfoWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('$key: $value', style: Theme.of(context).textTheme.bodySmall),
          ),
        );
      });
      productInfoWidgets.add(const SizedBox(height: 10));
    }

    //Nutriscore
    String? nutriScore = product.nutriscore;
    if (nutriScore != null && nutriScore.isNotEmpty && nutriScore != 'unknown') {
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