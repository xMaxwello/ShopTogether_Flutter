import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/group/MyAddGroupWidget.dart';
import 'package:shopping_app/components/memberRequest/MyInMemberRequestWidget.dart';
import 'package:shopping_app/functions/dialog/MyDialog.dart';
import 'package:shopping_app/functions/dialog/groupDialog/newGroupDialog.dart';
import 'package:shopping_app/functions/providers/group/MyGroupProvider.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/membersRequest/MyMembersRequestService.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';
import 'package:shopping_app/objects/requests/MyRequestGroup.dart';

import '../../exceptions/MyCustomException.dart';

class MyGroupBottomSheet {

  static List<Widget> generateBottomSheet(BuildContext context) {

    return [

      const SizedBox(height: 10,),
      Center(
        child: Text(
          "Gruppe hinzufügen",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      const SizedBox(height: 20,),

      Consumer<MyGroupProvider>(
          builder: (BuildContext context, MyGroupProvider myGroupProvider, Widget? child) {

            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                MyAddGroupWidget(
                  title: "Gruppe erstellen",
                  subtitle: "Hier können Sie Ihre eigene \n Gruppe erstellen!",
                  function: () => newGroupDialog(context),
                ),
                if (myGroupProvider.isShowWidget) ///switchs between the join group button and the enter code to join to a group widget
                  MyInMemberRequestWidget(
                      title: "Gruppe beitreten",
                      onNumbersEntered: (List<String> enteredNumbers) async {

                        String joinedNumbers = enteredNumbers.join('');
                        int joinedNumbersAsInt = int.parse(joinedNumbers);

                        try {

                          MyRequestGroup myRequestGroup = await MyFirestoreService.requestService.getInfosAboutSession(joinedNumbersAsInt);
                          bool isUserAleadyInGroup = await MyFirestoreService.groupService.isCurrentUserInGroup(myRequestGroup.groupUUID);
                          
                          if (!isUserAleadyInGroup) {

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

                                    ///TODO: Gucken ob das klappt
                                    //await MyFirestoreService.userService.addGroupUUIDsToUser(user.uid, myRequestGroup.groupUUID);
                                    //await MyFirestoreService.groupService.addUserUUIDToGroup(myRequestGroup.groupUUID, user.uid);
                                    //MyFirestoreService.requestService.removeRequestWithCode(joinedNumbersAsInt);
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

                                        case "group-user-not-exists":
                                          print(e.message);
                                          break;

                                        case "request-not-exists":
                                          print(e.message);
                                          break;

                                        case "snapchot-not-exists":
                                          print(e.message);
                                          break;
                                      }
                                    }
                                  }
                                }
                            );
                          } else {
                            
                            MySnackBarService.showMySnackBar(context, "Sie sind bereits in dieser Gruppe!");
                            Navigator.pop(context);
                          }
                          
                          Provider.of<MyGroupProvider>(context, listen: false).updateShowWidget(false);
                        } on MyCustomException catch(e) {

                          switch(e.keyword) {
                            case "no-requestCode":
                              MySnackBarService.showMySnackBar(context, "Der eingegebene Code existiert nicht!");
                              Navigator.pop(context);
                              break;

                            case "snapshot-not-exists":
                              print(e.message);
                              break;
                          }
                        }
                      },
                  )
                else
                  MyAddGroupWidget(
                    title: "Gruppe beitreten",
                    subtitle: "Treten Sie hier einer \nanderen Gruppe per Code bei!",
                    function: () => Provider.of<MyGroupProvider>(context, listen: false).updateShowWidget(true),
                  ),

              ],
            );
          }
      ),

    ];
  }
}