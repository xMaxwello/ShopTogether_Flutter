import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/appBar/MyAppBar.dart';
import 'package:shopping_app/components/home/MyFloatingButton.dart';
import 'package:shopping_app/components/home/MyHomeList.dart';
import 'package:shopping_app/components/home/MyHomeNavigationBar.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';

import '../functions/floatingAction/MyFloatingActionFunctions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
    MyFloatingActionFunctions myFloatingActionFunctions = MyFloatingActionFunctions(context, "");

    return Consumer<MyItemsProvider>
      (builder: (context, MyItemsProvider myItemsProvider, child) {

      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: height),

          ///set the padding = status bar height
          child: MyHomeList(
            isGroup: true,
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

                ElevatedButton(
                  onPressed: myFloatingActionFunctions.addGroup,
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: Text(
                        "Gruppe Hinzufügen",
                        style: Theme.of(context).textTheme.displaySmall
                    ),
                  ),
                )

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
            isGroup: true
          ),
        ),

        floatingActionButton: MyFloatingButton(
          buttonTitle: 'Gruppe',
          iconData: Icons.group_add,
          function: myFloatingActionFunctions.addGroup,
          isChangeByScroll: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}
