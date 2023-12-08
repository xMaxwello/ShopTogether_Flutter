import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/users/MyUserWidget.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';
import 'package:shopping_app/objects/users/MyUsers.dart';

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

      FutureBuilder<Stream<List<MyUser>>>(
          future: MyFirestoreService.groupService.getMembersAsStream(selectedGroupUUID),
          builder: (BuildContext context, AsyncSnapshot<Stream<List<MyUser>>> snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return StreamBuilder<List<MyUser>>(
                stream: snapshot.data,
                builder: (BuildContext context, AsyncSnapshot<List<MyUser>> memberSnapshots) {

                  if (memberSnapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!memberSnapshots.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<MyUser> myUser = memberSnapshots.data!;

                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView(
                          shrinkWrap: true,
                          children: [

                            for (int i = 0;i < myUser.length;i++)
                              MyUserWidget(
                                groupUUID: selectedGroupUUID,
                                myUser: myUser.elementAt(i),
                              ),

                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }
      ),

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