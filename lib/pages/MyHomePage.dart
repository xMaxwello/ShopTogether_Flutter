import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/home/MyFloatingButton.dart';
import 'package:shopping_app/components/home/MyHomeList.dart';
import 'package:shopping_app/components/home/MyHomeNavigationBar.dart';
import 'package:shopping_app/objects/groups/MyGroup.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    ///get status bar height
    double height = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: height), ///set the padding = status bar height
        child: const MyHomeList(
          isListEmptyWidget: Text("Die Liste is leer"),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.2),
        child: const MyHomeNavigationBar(),
      ),
      floatingActionButton: const MyFloatingButton(
        buttonTitle: 'Group',
        iconData: Icons.group_add,
        isChangeByScroll: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
