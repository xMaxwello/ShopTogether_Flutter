import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/users/MyUserWidget.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';
import 'package:shopping_app/objects/requests/MyRequestKey.dart';
import 'package:shopping_app/objects/users/MyUsers.dart';

import '../memberRequest/MyOutMemberRequestWidget.dart';

class MyMemberBottomSheet {

  static List<Widget> generateBottomSheet(BuildContext context, String selectedGroupUUID) {
    
    return [
      
      const SizedBox(height: 10,),
      Center(
        child: Text(
            "Mitglieder",
          style: Theme.of(context).textTheme.displayLarge,
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

      FutureBuilder(
          future: MyFirestoreService.requestService.getRequestWithGroupUUID(selectedGroupUUID),
          builder: (BuildContext context, AsyncSnapshot<MyRequestKey> snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: FloatingActionButton.extended(
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Mitglied',
                    style: Theme.of(context).textTheme.labelMedium,
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
      )

    ];
  }
}