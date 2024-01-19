import 'dart:async';

import 'package:openfoodfacts/openfoodfacts.dart';

class MyOpenFoodFactsService {

  MyOpenFoodFactsService() {

    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'shopping_app',
    );

    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.GERMAN
    ];

    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.GERMANY;
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

      return null;
    }
  }

  Future<SearchResult?> getProductByName(List<String> terms, int sizeOfProducts) async {

    var parameters = <Parameter>[
      PageSize(size: sizeOfProducts),
      const SortBy(option: SortOption.POPULARITY),
      SearchTerms(terms: terms),
    ];

    ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
        parametersList: parameters,
        language: OpenFoodFactsLanguage.GERMAN,
        version: ProductQueryVersion.v3,
        fields: [ProductField.BARCODE, ProductField.NAME, ProductField.BRANDS, ProductField.QUANTITY, ProductField.LABELS, ProductField.CATEGORIES, ProductField.NUTRISCORE, ProductField.INGREDIENTS_TEXT, ProductField.NUTRIMENTS, ProductField.SERVING_SIZE, ProductField.IMAGE_FRONT_URL]
    );

    SearchResult result =
    await OpenFoodAPIClient.searchProducts(null, configuration);

    return result;
  }

  Future<int> getMaximumProductSize(List<String> terms) async {

    var parameters = <Parameter>[
      const PageSize(size: 999999999999999999),
      const SortBy(option: SortOption.POPULARITY),
      SearchTerms(terms: terms),
    ];

    ProductSearchQueryConfiguration configuration = ProductSearchQueryConfiguration(
        parametersList: parameters,
        language: OpenFoodFactsLanguage.GERMAN,
        version: ProductQueryVersion.v3,
        fields: [ProductField.BARCODE, ProductField.NAME, ProductField.BRANDS, ProductField.QUANTITY, ProductField.LABELS, ProductField.CATEGORIES, ProductField.NUTRISCORE, ProductField.INGREDIENTS_TEXT, ProductField.NUTRIMENTS, ProductField.SERVING_SIZE, ProductField.IMAGE_FRONT_URL]
    );

    SearchResult result =
        await OpenFoodAPIClient.searchProducts(null, configuration);

    return result.count ?? 0;
  }

  Future<List<Product>> getProducts(String productName, int sizeOfProducts) async {

    SearchResult? searchResult = await getProductByName([productName], sizeOfProducts);

    if (searchResult == null) {
      return [];
    }

    if (searchResult.products == null) {
      return [];
    }

    return searchResult.products!;
  }
}