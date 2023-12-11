import 'package:firebase_auth/firebase_auth.dart';

import '../../objects/groups/MyGroup.dart';
import '../../objects/products/MyProduct.dart';

class MySortHandler {

  static List<List<MyProduct>>? getProductsForUsers(List<MyProduct>? products, List<String>? userUUIDs) {

    if (products == null || userUUIDs == null) {
      return null;
    }

    List<List<MyProduct>> productsForUsers = [];
    for (String userUUID in userUUIDs) {
      List<MyProduct> filteredProducts = products.where((product) => product.selectedUserUUID == userUUID).toList();
      productsForUsers.add(filteredProducts);
    }

    return productsForUsers;
  }

  static List<MyProduct>? getSortProductList(bool isGroup, User user, List<MyGroup> groupsFromUser, int selectedGroupIndex) {

    List<MyProduct>? products;
    if (isGroup) {
      return null;
    }
    products = groupsFromUser.elementAt(selectedGroupIndex).products;

    ///sort the products to the product names
    products.sort((a, b) => a.compareNameTo(b));

    ///sort the products to the selected user, but the current users products are any time at the top
    products.sort((a, b) {
      if (a.selectedUserUUID == user.uid) {
        return -1;
      } else if (b.selectedUserUUID == user.uid) {
        return 1;
      }

      return a.compareNameTo(b);
    });
    return products;
  }
}