import 'package:shopping_app/exceptions/MyCustomException.dart';
import '../firestore/MyFirestoreService.dart';

class MyMembersRequestService {

  /// [userUUID] => the user uuid who want to add
  /// [groupUUID] => the group uuid where the user uuid want to add
  ///
  /// [MyCustomException] Keys:
  ///- group-not-exists: the groupUUID or the userUUID doesn't exist!
  ///- request-not-exists: the request code doesn't exist!
  ///- user-exists: the user exists already in group!
  ///- Has Keys from [MyFirestoreService.userService.addGroupUUIDsFromUser]
  ///  and [MyFirestoreService.groupService.addUserUUIDToGroup]
  static void addUserToGroupOverRequest(String userUUID, String groupUUID, int requestCode) async {

    bool existsUser = await MyFirestoreService.userService.isUserExists(userUUID);
    bool existsGroup = await MyFirestoreService.groupService.isGroupExists(groupUUID);

    if (!existsGroup) {
      throw MyCustomException("the groupUUID doesn't exist!",
          "group-not-exists");
    }

    if (existsUser) {
      throw MyCustomException("the user exists already in group!",
          "user-exists");
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