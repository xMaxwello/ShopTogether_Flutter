import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/bottomSheetItems/memberBottomSheet/MyMemberListForSheet.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';

import '../memberRequest/MyOutMemberRequestWidget.dart';

class MyMemberBottomSheet {

  static List<Widget> generateBottomSheet(BuildContext context, String selectedGroupUUID) {

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const [
        Center(
          child: CircularProgressIndicator(),
        )
      ];
    }

    return [
      
      const SizedBox(height: 10,),
      Center(
        child: Text(
            "Mitglieder",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      const SizedBox(height: 20,),

      ///shows the list of members of the group
      MyMemberListForSheet(selectedGroupUUID: selectedGroupUUID),

      const SizedBox(height: 10,),

      FutureBuilder<bool>(
          future: MyFirestoreService.groupService.isUserGroupOwner(selectedGroupUUID, user.uid),
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

            return StreamBuilder(
                stream: MyFirestoreService.requestService.getRequestWithGroupUUIDAsStream(selectedGroupUUID),
                builder: (BuildContext context, AsyncSnapshot<MyRequestKey> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshotIsCurrentUserOwner.data!) {
                    return const SizedBox();
                  }

                  ///shows the add button for the "join-key"
                  if (!snapshot.hasData) {
                    return Center(
                      child: FloatingActionButton.extended(
                        icon: const Icon(Icons.add),
                        label: Text(
                          'Mitglied',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        onPressed: () async {

                          await MyFirestoreService.requestService.addRequestForSession(
                              MyRequestKey(
                                  groupUUID: selectedGroupUUID
                              )
                          );
                        },
                      ),
                    );
                  }

                  ///shows the current "join-key" for the current group
                  return Center(
                    child: MyOutMemberRequestWidget(
                      requestCode: snapshot.data!.requestCode.toString(),
                      title: 'Session Code',
                    ),
                  );
                }
            );
          }
      )

    ];
  }
}