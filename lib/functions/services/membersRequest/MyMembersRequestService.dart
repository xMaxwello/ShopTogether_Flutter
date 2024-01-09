
import 'package:shopping_app/exceptions/MyCustomException.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';

import '../../../objects/requests/MyRequestGroup.dart';
import '../firestore/MyFirestoreService.dart';

class MyMembersRequestService {

  /// [userUUID] => the user uuid who want to add
  /// [groupUUID] => the group uuid where the user uuid want to add
  ///
  /// [MyCustomException] Keys:
  ///- group-not-user-exists: the groupUUID or the userUUID doesn't exist!
  ///- request-not-exists: the request code doesn't exist!
  ///- Has Keys from [MyFirestoreService.userService.addGroupUUIDsFromUser]
  ///  and [MyFirestoreService.groupService.addUserUUIDToGroup]
  static void addUserToGroupOverRequest(String userUUID, String groupUUID, int requestCode) async {

    bool existsUser = await MyFirestoreService.userService.isUserExists(userUUID);
    bool existsGroup = await MyFirestoreService.groupService.isGroupExists(groupUUID);

    bool contuine = existsUser && existsGroup;
    if (!contuine) {
      throw MyCustomException("the groupUUID or the userUUID doesn't exist!",
          "group-not-user-exists");
    }

    bool existsRequest = await MyFirestoreService.requestService.isRequestCodeExists(requestCode);
    if (!existsRequest) {

      throw MyCustomException("the request code doesn't exist!",
          "request-not-exists");
    }

    try {

      await MyFirestoreService.userService.addGroupUUIDsToUser(userUUID, groupUUID);
      await MyFirestoreService.groupService.addUserUUIDToGroup(groupUUID, userUUID);
      MyFirestoreService.requestService.removeRequestWithCode(requestCode);
    } on MyCustomException catch(e) {

      throw MyCustomException(e.message, e.keyword);
    }
  }

  static Future<int> getRequestCode() async {

    return await MyFirestoreService.requestService.generateNotUsedRequestCode();
  }
}