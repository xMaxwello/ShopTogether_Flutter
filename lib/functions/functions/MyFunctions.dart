import '../../objects/groups/MyGroup.dart';
import '../firestore/MyFirestore.dart';

class MyFunctions {

  static void addGroup() {

    MyFirestore.addGroup(
        MyGroup(
            groupID: "fdsdg-fdsfd",
            groupName: "Hallo",
            userUUIDs: [],
            products: []
        )
    );
  }
}