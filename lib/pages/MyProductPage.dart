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
import '../functions/providers/search/MySearchProvider.dart';

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

    Future.delayed(const Duration(microseconds: 50), () {
      Provider.of<MyItemsProvider>(context, listen: false).updateIsGroup(false);
      Provider.of<MySearchProvider>(context, listen: false).updateIsSearching(false);
    });

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
    final isSearchActive = Provider.of<MySearchProvider>(context).isSearching;

    ///get status bar height
    double height = MediaQuery.of(context).padding.top;

    return Consumer<MyItemsProvider>
      (builder: (context, MyItemsProvider myItemsProvider, child) {

      MyFloatingActionFunctions myFloatingActionFunctions = MyFloatingActionFunctions(context, myItemsProvider.selectedGroupUUID);
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return FutureBuilder<bool>(
          future: MyFirestoreService.groupService.isUserGroupOwner(myItemsProvider.selectedGroupUUID, user.uid),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(top: height),

                  ///set the padding = status bar height
                  child: MyHomeList(
                    isListEmptyWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                            "Die Liste ist leer!",
                            style: Theme.of(context).textTheme.labelSmall
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

                floatingActionButton: MyFloatingButton(
                    buttonTitle: isSearchActive ? 'Produkt\n hinzufügen' : 'Mitglied',
                    iconData: isSearchActive ? Icons.add : Icons.person,
                    function: isSearchActive ? myFloatingActionFunctions.addCustomProduct : myFloatingActionFunctions.addUserToGroup,
                    isChangeByScroll: true
                ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            );
          }
      );
    });
  }
}

