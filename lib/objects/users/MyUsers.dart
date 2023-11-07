import 'package:flutter/foundation.dart';

class MyUser extends ChangeNotifier {
  final String uuid;
  final String prename;
  final String surname;
  final List<String> groupUUIDs;

  MyUser({
    required this.uuid,
    required this.prename,
    required this.surname,
    required this.groupUUIDs,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'prename': prename,
      'surname': surname,
      'groupUUIDs': groupUUIDs,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uuid: map['uuid'] as String,
      prename: map['prename'] as String,
      surname: map['surname'] as String,
      groupUUIDs: (map['groupUUIDs'] as List).cast<String>(),
    );
  }
}
