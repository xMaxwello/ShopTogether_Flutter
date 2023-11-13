import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../functions/providers/items/MyItemsProvider.dart';
import '../search/MySearchBar.dart';

class MyAppBar extends StatefulWidget {

  final bool isGroup;

  const MyAppBar({super.key, required this.isGroup});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Consumer<MyItemsProvider>(
          builder: (BuildContext context,
              MyItemsProvider value,
              Widget? child){

            if (widget.isGroup) {
              return Column(
                children: [

                  const SizedBox(
                    height: 60,
                  ),

                  Text(
                    "Einkaufsapp",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge
                  ),

                ]
              );
            }

            return const Column(
              children: [

                SizedBox(
                  height: 40,
                ),

                ///the search bar for the products
                MySearchBar(),

              ],
            );
          }),
    );
  }
}
