import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';

import '../../objects/users/MyUsers.dart';

class MyUserWidget extends StatelessWidget {

  final MyUser myUser;
  final String groupUUID;

  const MyUserWidget({super.key, required this.myUser, required this.groupUUID});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.transparent,
      title: Text(
        "${myUser.prename} ${myUser.surname}",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      leading: Icon(
        Icons.person,
        color: Theme.of(context).iconTheme.color,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.remove_circle),
        color: Colors.red[700],
        onPressed: () async {

          if (await MyFirestoreService.groupService.isCurrentUserGroupOwner(groupUUID) == false) {

            await MyFirestoreService.groupService.removeUserUUIDToGroup(groupUUID, myUser.uuid);
          } else {

            ///TODO: Die Snackbar wird von dem BottomSheet überdeckt
            MySnackBarService.showMySnackBar(context, "Als Gruppen-Owner dürfen Sie sich nicht löschen!");
          }
        },
      ),
    );
  }
}
