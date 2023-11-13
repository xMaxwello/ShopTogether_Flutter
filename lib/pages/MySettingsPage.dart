import 'package:flutter/material.dart';
import 'package:shopping_app/components/settings/MySettingsWidget.dart';

import '../components/home/MyHomeNavigationBar.dart';

class MySettingsPage extends StatelessWidget {
  const MySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const MySettingsWidget(),

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
    );
  }
}
