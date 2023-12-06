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

    var parameters = <Parameter>[
      const PageSize(size: 10),
      const SortBy(option: SortOption.POPULARITY),
      SearchTerms(terms: terms),
    ];

    ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
        parametersList: parameters,
        language: OpenFoodFactsLanguage.GERMAN,
        version: ProductQueryVersion.v3
    );

    SearchResult result =
    await OpenFoodAPIClient.searchProducts(null, configuration);

    return result;
  }
}