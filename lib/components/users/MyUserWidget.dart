import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/functions/services/snackbars/MySnackBarService.dart';

import '../../objects/users/MyUsers.dart';

/**
 * The widget, which shows the users in the MyMemberListForSheet in the MyMemberBottomSheet
 * */
class MyUserWidget extends StatelessWidget {

  final MyUser myUser;
  final String groupUUID;

  const MyUserWidget({super.key, required this.myUser, required this.groupUUID});

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FutureBuilder<bool>(
        future: MyFirestoreService.groupService.isUserGroupOwner(groupUUID, user.uid),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshotIsCurrentUserOwner) {

          if (snapshotIsCurrentUserOwner.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshotIsCurrentUserOwner.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return FutureBuilder<bool>(
              future: MyFirestoreService.groupService.isUserGroupOwner(groupUUID, myUser.uuid),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshotIsUserOwner) {

                if (snapshotIsUserOwner.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshotIsUserOwner.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListTile(
                  tileColor: Colors.transparent,
                  title: Text(
                    "${myUser.prename} ${myUser.surname}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  trailing: snapshotIsUserOwner.data! || snapshotIsCurrentUserOwner.data! == false ?
                  null
                      :
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red[700],
                    onPressed: () async {

                      if (snapshotIsUserOwner.data == false) {

                        await MyFirestoreService.groupService.removeUserUUIDFromGroup(groupUUID, myUser.uuid);
                        MyFirestoreService.userService.removeGroupUUIDsFromUser(myUser.uuid, groupUUID);

                        ///remove UserUUID of the products, who should buy this product. (selectedUserUUID)
                        List<String?>? productUUIDs = await MyFirestoreService.productService.getProductUUIDsOfSelectedUser(groupUUID, myUser.uuid);
                        for (String? productUUID in productUUIDs!) {

                          MyFirestoreService.productService.updateSelectedUserOfProduct(groupUUID, productUUID!, "");
                        }
                      } else {

                        MySnackBarService.showMySnackBar(context, "Als Gruppen-Owner dürfen Sie sich nicht löschen!");
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              }
          );
        }
    );
  }
}