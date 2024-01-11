import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/objects/requests/MyRequestGroup.dart';

import '../../../exceptions/MyCustomException.dart';
import '../../../functions/dialog/MyDialog.dart';
import '../../../functions/services/firestore/MyFirestoreService.dart';
import '../../../functions/services/membersRequest/MyMembersRequestService.dart';
import '../../../functions/services/snackbars/MySnackBarService.dart';

class MyGroupBottomSheetDialog {

  static void showGroupDialog(BuildContext context, MyRequestGroup myRequestGroup, int joinedNumbersAsInt) async {

    String groupName = await MyFirestoreService.groupService.getNameOfGroup(myRequestGroup.groupUUID);
    int membersSize = await MyFirestoreService.groupService.getSizeOfMembers(myRequestGroup.groupUUID);
    List<String> names = await MyFirestoreService.userService.getNameOfUser(myRequestGroup.userOwnerUUID);
    String fullName = names.join(' ');

    MyDialog.showCustomDialog(
        context: context,
        title: "Möchtest du dieser Gruppe beitreten?",
        contentBuilder: (dialogContext) => [
          Text(
            "Gruppenname: $groupName",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "Anzahl der Mitglieder: $membersSize",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "Besitzer: $fullName",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        onConfirm: () async {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {

            try {

              MyMembersRequestService
                  .addUserToGroupOverRequest(
                  user.uid, myRequestGroup.groupUUID,
                  joinedNumbersAsInt);
              MySnackBarService.showMySnackBar(context,
                  "Sie wurden zur Gruppe hinzugefügt!",
                  isError: false);
              Navigator.pop(context);
            } on MyCustomException catch(e) {

              switch (e.keyword) {

                case "group-not-exists":
                  MySnackBarService.showMySnackBar(context,
                      "Der eingegebene Code ist falsch!",
                      isError: false);
                  break;

                case "user-exists":
                  MySnackBarService.showMySnackBar(context,
                      "Sie sind bereits in dieser Gruppe!",
                      isError: false);
                  break;

                case "request-not-exists":
                  MySnackBarService.showMySnackBar(context,
                      "Der eingegebene Code ist falsch!",
                      isError: false);
                  break;

                case "snapchot-not-exists":
                  print(e.message);
                  break;
              }
            }
          }
        }
    );
  }
}