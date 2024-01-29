import 'package:flutter/material.dart';

import '../../../functions/services/firestore/MyFirestoreService.dart';
import '../../../objects/users/MyUsers.dart';
import '../../users/MyUserWidget.dart';

class MyMemberListForSheet extends StatelessWidget {

  final String selectedGroupUUID;

  const MyMemberListForSheet({super.key, required this.selectedGroupUUID});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: MyFirestoreService.groupService.getMembersAsStream(selectedGroupUUID),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

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
    );
  }
}
