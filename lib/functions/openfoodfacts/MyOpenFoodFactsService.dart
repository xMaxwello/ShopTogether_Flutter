
import 'package:openfoodfacts/openfoodfacts.dart';

class MyOpenFoodFactsService {

  MyOpenFoodFactsService() {

    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'shopping_app',
    );

    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.GERMAN
    ];

    /*
    OpenFoodAPIConfiguration.globalUser = User(
    userId: 'myUsername',
    password: 'myPassword',
    );
    * */
  }

  Future<Product?> getProductByBarcode(String barcode) async {

    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.GERMAN,
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess) {
      return result.product;
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }
}