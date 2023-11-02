import 'package:flutter/foundation.dart';

class MyUser extends ChangeNotifier {
  final String userUUID;
  final String prename;
  final String surname;
  final List<String> groupUUIDs;

  MyUser({required this.prename, required this.surname, required this.groupUUIDs, required this.userUUID,});
}
