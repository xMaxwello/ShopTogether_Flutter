import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/functions/services/firestore/MyFirestoreService.dart';

import '../components/appBar/MyAppBar.dart';
import '../components/home/MyFloatingButton.dart';
import '../components/home/MyHomeList.dart';
import '../components/home/MyHomeNavigationBar.dart';
import '../functions/floatingAction/MyFloatingActionFunctions.dart';
import '../functions/providers/items/MyItemsProvider.dart';

class MyProductPage extends StatefulWidget {
  const MyProductPage({super.key});

  @override
  State<MyProductPage> createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    ///Refreshs the current user
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.reload();
        }
      } catch(e) {
        print(e.toString());
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ///get status bar height
    double height = MediaQuery.of(context).padding.top;

    return Consumer<MyItemsProvider>
      (builder: (context, MyItemsProvider myItemsProvider, child) {

      MyFloatingActionFunctions myFloatingActionFunctions = MyFloatingActionFunctions(context, myItemsProvider.selectedGroupUUID);

      return FutureBuilder<bool>(
          future: MyFirestoreService.groupService.isCurrentUserGroupOwner(myItemsProvider.selectedGroupUUID),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(top: height),

                  ///set the padding = status bar height
                  child: MyHomeList(
                    isGroup: false,
                    isListEmptyWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                            "Die Liste ist leer!",
                            style: Theme.of(context).textTheme.bodySmall
                        ),
                        const SizedBox(height: 10,),

                      ],
                    ),
                  ),
                ),
                bottomNavigationBar:  ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: BottomAppBar(
                    color: Theme.of(context).bottomAppBarTheme.color,
                    child: const MyHomeNavigationBar(),
                  ),
                ),

                appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(100),
                  child: MyAppBar(
                    isGroup: false,
                  ),
                ),

                floatingActionButton: snapshot.data ?
                MyFloatingButton(
                buttonTitle: 'Mitglied',
                iconData: Icons.person_add,
                function: myFloatingActionFunctions.addUserToGroup,
                isChangeByScroll: true
            ) : const SizedBox(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            );
          }
      );
    });
  }
}

