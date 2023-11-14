
import 'package:openfoodfacts/openfoodfacts.dart';

class MyOpenFoodFactsService {

  MyOpenFoodFactsService() {

    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'shopping_app',
    );

    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.GERMAN
    ];
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

  Future<SearchResult?> getProductByName(List<String> terms) async {

    ///TODO: Hier

    final ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
        parametersList: [
          StatesTagsParameter(
              map: {}
          ),
        ],
        version: ProductQueryVersion.v3
    );

    User user = const User(
        userId: "mopa",
        password: ""
    );
    final SearchResult result = await OpenFoodAPIClient.searchProducts(user, configuration);

    return result;
  }
}