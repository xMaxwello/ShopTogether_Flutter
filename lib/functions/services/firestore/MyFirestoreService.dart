import 'package:shopping_app/functions/services/firestore/subclasses/GroupService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/ProductService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/RequestService.dart';
import 'package:shopping_app/functions/services/firestore/subclasses/UserService.dart';


class MyFirestoreService {

  static final ProductService productService = ProductService();
  static final GroupService groupService = GroupService();
  static final UserService userService = UserService();
  static final RequestService requestService = RequestService();
}